use dep::smt::{bn254::poseidon2_smt, SMT, SMTProof, Operation};

fn main(proof: SMTProof<Field, Field, Field, 160>, op: pub Field, op_key: pub Field, op_value: pub Field, root: pub Field) -> pub Field
{
    let smt: SMT<Field, Field, Field, 160> = poseidon2_smt();
    smt.compute_root(smt.process(proof,op, op_key, op_value, root))
}
