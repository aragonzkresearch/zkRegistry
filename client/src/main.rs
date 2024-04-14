use std::path::PathBuf;

use clap::{Parser, Subcommand};

use ethers::abi::AbiEncode;
use ethers::core::k256::ecdsa::SigningKey;
use ethers::core::rand;
use ethers::prelude::{
    abigen, Address, BigEndianHash, Http, LocalWallet, Middleware, Provider, ProviderExt, Signer,
    SignerMiddleware, TransactionRequest, Wallet,
};

use ethers::types::{Bytes, H256, U256, U64};

use std::ffi::{c_char, CStr};
use std::fs::File;
use std::io::Read;
use std::str::FromStr;
use zkhash::fields::utils::from_hex;

use serde::{Deserialize, Serialize};

type Scalar = zkhash::fields::bn256::FpBN256;

use lazy_static::lazy_static;
use std::sync::Arc;

type Error = Box<dyn std::error::Error>;

abigen!(
    OffchainRegistry,
    r#"[
        event smt_op(uint256 indexed op, address indexed addr,  uint256 indexed value)
        function root() public view returns (uint256)
        function submit_op(uint256 op, uint256 value, uint256 new_root, bytes calldata op_proof) public returns (bool)
        function submit_batch_op(uint256 num_ops, uint256[5] calldata ops, address[5] calldata addresses, uint256[5] calldata values, uint256 new_root, bytes calldata op_proof) public returns (bool)
    ]"#,
);

#[derive(Serialize, Deserialize, Debug)]
struct SMTProof {
    inclusion: bool,
    empty_leaf: bool,
    key: String,
    value: String,
    siblings: Vec<String>,
}

#[derive(Serialize, Deserialize, Debug)]
struct SMTRoot(String);

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    /// Ethereum JSON RPC URL
    #[arg(long, value_name = "RPC_URL", env)]
    rpc_url: String,

    /// zkRegistry contract address
    #[arg(long, value_name = "ADDRESS", env)]
    zkregistry_contract: Address,

    /// zkRegistry server URL
    #[arg(long, value_name = "URL", env)]
    zkregistry_url: String,

    /// Private key
    #[arg(short, long, value_name = "KEY", env)]
    private_key: String,

    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    /// Insert a secret identity key
    Insert { value: U256 },
    /// Update a secret identity key
    Update { value: U256 },
    /// Delete a secret identity key
    Delete,
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let cli = Cli::parse();

    let private_key = hex::decode(cli.private_key).unwrap();
    let wallet = LocalWallet::from_bytes(&private_key).unwrap();

    let (op, value) = match cli.command {
        Some(Commands::Insert { value }) => Ok((0, Some(value))),
        Some(Commands::Update { value }) => Ok((1, Some(value))),
        Some(Commands::Delete) => Ok((2, None)),
        None => Err("Invalid command."),
    }?;

    apply_op(
        &cli.rpc_url,
        cli.zkregistry_contract,
        &cli.zkregistry_url,
        wallet,
        op,
        value,
    )
    .await
}

async fn get_smt_op_proof(
    zkregistry_url: &str,
    op: usize,
    key: Address,
) -> Result<SMTProof, Error> {
    reqwest::get(
        zkregistry_url.to_string()
            + "/op-proof/"
            + op.to_string().as_str()
            + "/"
            + &key.encode_hex()[2..],
    )
    .await?
    .json::<SMTProof>()
    .await
    .map_err(|e| e.into())
}

async fn get_smt_root(zkregistry_url: &str) -> Result<SMTRoot, Error> {
    reqwest::get(zkregistry_url.to_string() + "/root")
        .await?
        .json::<SMTRoot>()
        .await
        .map_err(|e| e.into())
}

async fn submit_op(
    client: SignerMiddleware<Provider<Http>, LocalWallet>,
    contract_address: Address,
    op: U256,
    value: U256,
    new_root: U256,
    op_proof: &[u8],
) -> Result<H256, Error> {
    let offchain_registry = OffchainRegistry::new(contract_address, client.into());
    let submit_request = offchain_registry.submit_op(op, value, new_root, op_proof.to_vec().into());

    let tx = submit_request.send().await?;

    Ok(tx.tx_hash())
}

async fn apply_op(
    rpc_url: &str,
    zkregistry_contract: Address,
    zkregistry_url: &str,
    wallet: LocalWallet,
    op: usize,
    value: Option<U256>,
) -> Result<(), Error> {
    // Fetch SMT proof
    println!("Fetching SMT proof...");
    let smt_op_proof = get_smt_op_proof(zkregistry_url, op, wallet.address()).await?;
    let smt_root = get_smt_root(zkregistry_url).await?;

    // Noir transaction proof
    println!("Generating Noir proof...");
    let (proof, new_root) =
        prove_smt_transaction(op, wallet.address(), value, smt_op_proof, smt_root);

    // Submission to Ethereum smart contract
    println!("Submitting proof to smart contract...");
    let connection = Provider::<Http>::connect(rpc_url).await;
    let chain_id = connection.get_chainid().await?;
    let client = SignerMiddleware::new(connection.clone(), wallet.with_chain_id(chain_id.as_u64()));

    match submit_op(
        client,
        zkregistry_contract,
        U256::from_dec_str(op.to_string().as_str()).unwrap(),
        value.unwrap_or(U256::zero()),
        new_root,
        &proof,
    )
    .await
    {
        Ok(tx_hash) => println!(
            "Transaction submitted successfully with transaction hash {}!",
            tx_hash
        ),
        Err(e) => println!("Transaction failed: {}", e),
    }

    Ok(())
}

pub fn prove_smt_transaction(
    op: usize,
    address: Address,
    value: Option<U256>,
    smt_op_proof: SMTProof,
    smt_root: SMTRoot,
) -> (Vec<u8>, U256) {
    let smt_op_circuit = include_str!("../../circuits/single_smt_op/src/main.nr");
    let smt_op_circuit_config_toml = include_str!("../../circuits/single_smt_op/Nargo.toml");

    // Form Prover.toml
    let mut toml_map = toml::map::Map::new();
    let mut proof_toml_map = toml::map::Map::new();

    let value_string = value.map(|v| v.encode_hex()).unwrap_or("0x00".to_string());

    proof_toml_map.insert(
        "siblings".to_string(),
        toml::Value::try_from(smt_op_proof.siblings).unwrap(),
    );
    proof_toml_map.insert(
        "empty_leaf".to_string(),
        toml::Value::try_from(smt_op_proof.empty_leaf).unwrap(),
    );
    proof_toml_map.insert(
        "key".to_string(),
        toml::Value::try_from(smt_op_proof.key).unwrap(),
    );
    proof_toml_map.insert(
        "value".to_string(),
        toml::Value::try_from(smt_op_proof.value).unwrap(),
    );

    toml_map.insert("proof".to_string(), toml::Value::Table(proof_toml_map));
    toml_map.insert(
        "op".to_string(),
        toml::Value::try_from(op.to_string()).unwrap(),
    );
    toml_map.insert(
        "op_key".to_string(),
        toml::Value::try_from(address.encode_hex()).unwrap(),
    );
    toml_map.insert(
        "op_value".to_string(),
        toml::Value::try_from(value_string).unwrap(),
    );
    toml_map.insert(
        "root".to_string(),
        toml::Value::try_from(smt_root.0).unwrap(),
    );

    let (proof, verifier_toml) = run_singleton_noir_project(
        smt_op_circuit_config_toml,
        smt_op_circuit,
        toml::Value::Table(toml_map),
    )
    .unwrap();
    let return_value = verifier_toml.get("return").unwrap().to_string();

    (
        proof,
        U256::from_str_radix(&return_value[3..67], 16).unwrap(),
    )
}

/// A function for compiling a Noir program consisting of only a `main.nr`.
/// The circuit (i.e. `main.nr`) and the `Nargo.toml` file are passed in as string slices.
/// The returned value is a tuple consisting of the proof and the `Verifier.toml`.
pub fn run_singleton_noir_project(
    circuit_config_toml: &str,
    circuit: &str,
    prover_toml: toml::Value,
) -> Result<(Vec<u8>, toml::Value), Error> {
    // Extract package name from Nargo.toml (required to read proof back in)
    let pkg_name = {
        let pkg = circuit_config_toml
            .parse::<toml::Table>()
            .expect("Error parsing circuit config Toml.")
            .get("package")
            .expect("Error: Circuit config is missing `package` field.")
            .to_owned();
        let wrapped_pkg_name = match pkg {
            toml::Value::Table(t) => t
                .get("name")
                .expect("Error: Circuit config is missing package name!")
                .to_owned(),
            _ => panic!("Nargo.toml invalid!"),
        };

        match wrapped_pkg_name {
            toml::Value::String(s) => s,
            _ => panic!("Nargo.toml invalid!"),
        }
    };

    // Prepare temporary directory
    let tmp_dir = tempdir::TempDir::new("noir")?;

    // Write Nargo.toml
    let circuit_config_toml_path = tmp_dir.path().join("Nargo.toml");
    std::fs::write(circuit_config_toml_path, circuit_config_toml)?;

    // Create src directory and place `main.nr` in it
    std::fs::create_dir(tmp_dir.path().join("src"))?;
    let circuit_path = tmp_dir.path().join("src").join("main.nr");
    std::fs::write(circuit_path, circuit)?;

    // Write `Prover.toml`
    let prover_toml_path = tmp_dir.path().join("Prover.toml");
    let prover_toml_string =
        toml::to_string_pretty(&prover_toml).expect("Failed to construct Prover.toml.");
    std::fs::write(prover_toml_path, prover_toml_string)?;

    // Generate proof
    std::process::Command::new("nargo")
        .current_dir(&tmp_dir.path())
        .arg("prove")
        .output()?;

    // Read proof
    let proof_string = std::fs::read_to_string(
        &tmp_dir
            .path()
            .join("proofs")
            .join(format!("{}.proof", pkg_name)),
    )?;
    let proof = hex::decode(proof_string).expect("Error decoding proof string");

    //... and Verifier.toml
    let verifier_toml_path = tmp_dir.path().join("Verifier.toml");
    let mut verifier_toml_file = File::open(verifier_toml_path).unwrap();
    let mut verifier_toml_string = String::new();
    verifier_toml_file
        .read_to_string(&mut verifier_toml_string)
        .unwrap();

    Ok((proof, toml::from_str(&verifier_toml_string).unwrap()))
}
