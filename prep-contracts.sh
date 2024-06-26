#!/bin/bash
#circuit_dirs=("batch_smt_op" "single_smt_op")
circuit_dirs=("single_smt_op")
#circuits=("BatchSMTOp" "SingleSMTOp")
circuits=("SingleSMTOp")

generate_contract() {
	nargo codegen-verifier
}
copy_contract() {
        PKG_NAME=$(grep -o 'name.*=.*".*"' Nargo.toml | sed -e 's/name.*=.*\s//g' -e 's/"//g')
	FILE_STR=$(sed -e "s/UltraVerificationKey/$1UltraVerificationKey/g" -e '6iimport "./BaseUltraVerifier.sol";\n' contract/$PKG_NAME/plonk_vk.sol)
	echo "$FILE_STR" | head -n 75 > ../../contracts/src/$1Verifier.sol
	echo "contract $1Verifier is BaseUltraVerifier {" >> ../../contracts/src/$1Verifier.sol
	echo "$FILE_STR" | tail -n 8 >> ../../contracts/src/$1Verifier.sol
}

cur_dir=$(pwd)
for i in "${!circuits[@]}"
do
	cd circuits/${circuit_dirs[$i]}
	generate_contract
	copy_contract ${circuits[$i]}
	cd $cur_dir
done
