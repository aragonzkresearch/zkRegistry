use dep::smt::{bn254::poseidon2_smt, SMT, SMTProof, op::Operation};

global NUM_TRANSACTIONS = 10;

// Signature struct
struct Secp256k1Signature<N>
{
    pub_key: ([u8; 32], [u8; 32]),
    signature: [u8; 64],
    msg_hash: [u8; N]
}

impl<N> Secp256k1Signature<N>
{
    fn verify(self) -> bool
    {
        dep::std::ecdsa_secp256k1::verify_signature(self.pub_key.0, self.pub_key.1, self.signature, self.msg_hash)
    }
}

fn address_from_pubkey(pub_key: ([u8; 32], [u8; 32])) -> Field
{
    let mut arr = [0; 64];
    let mut address_bytes = [0; 32];

    for i in 0..32
    {
        arr[i] = pub_key.0[i];
        arr[32 + i] = pub_key.1[i];
    }

    let pk_hash = dep::std::hash::keccak256(arr, 64);

    for i in 0..20
    {
        address_bytes[12 + i] = pk_hash[12 + i];
    }

    dep::std::field::bytes32_to_field(address_bytes)
}

fn check_op(op: Field, op_key: Field, op_value: Field, root: Field, hash: [u8; 32]) -> bool
{
    let computed_hash = dep::std::hash::poseidon2::Poseidon2::hash([op, op_key, op_value, root], 4);

    let mut computed_hash_bytes = [0; 32];

    for i in 0..32
    {
        computed_hash_bytes[i] = computed_hash.to_be_bytes(32)[i];
    }

    hash == computed_hash_bytes
}

fn main(num_transactions: pub u32, proof: [SMTProof<Field, Field, Field, 160>; NUM_TRANSACTIONS], signature: [Secp256k1Signature<32>; NUM_TRANSACTIONS], op: pub [Field; NUM_TRANSACTIONS], address: pub [Field; NUM_TRANSACTIONS], op_value: pub [Field; NUM_TRANSACTIONS], root: pub Field, new_root: pub Field)
{
    let smt: SMT<Field, Field, Field, 160> = poseidon2_smt();
    let mut cur_root = root;
    
    for i in 0..NUM_TRANSACTIONS
    {
        if i < num_transactions
        {
//            assert(signature[i].verify()); // Check signature
            assert(address_from_pubkey(signature[i].pub_key) == address[i]); // Check address
            assert(check_op(op[i], address[i], op_value[i], cur_root, signature[i].msg_hash)); // Check message
            cur_root = smt.compute_root(smt.process(proof[i], op[i], address[i], op_value[i], cur_root)); // Compute new root
        }
    }

   assert(cur_root == new_root);
}
