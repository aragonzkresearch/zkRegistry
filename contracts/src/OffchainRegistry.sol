// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity ^0.8.13;

import "./BatchSMTOpVerifier.sol";
import "./SingleSMTOpVerifier.sol";

/// Rudimentary ZKRegistry contract where everything is stored onchain
contract OffchainRegistry
{

    event smt_op(uint256 indexed op, address indexed addr,  uint256 indexed value);
    
    BatchSMTOpVerifier private batch_op_verifier;
    SingleSMTOpVerifier private single_op_verifier;
    
    // The registry is stored off-chain as a sparse Merkle tree. Here we
    // keep track of the root, which is initialised to the default empty
    // value (0).
    uint256 private registry_root;

    // Upper bound on the maximum number of operations per batch proof.
    uint256 public constant MAX_OPS = 10;

    constructor(uint256 initial_root, BatchSMTOpVerifier _batch_op_verifier, SingleSMTOpVerifier _single_op_verifier)
	{
	    registry_root = initial_root;
	    batch_op_verifier = _batch_op_verifier;
	    single_op_verifier = _single_op_verifier;
	}

    function root() public view returns (uint256)
    {
	return registry_root;
    }
    
    // We allow users to insert/delete/update their value in the tree.

    // Submit single op
    function submit_op(uint256 op, uint256 value, uint256 new_root, bytes calldata op_proof) public returns (bool)
    {
	if(verify_op(op, value, new_root, op_proof))
	    {
		registry_root = new_root;
		emit smt_op(op, msg.sender, value);
		return true;
	    }

	return false;
    }
    
    // Verify single op
    function verify_op(uint256 op, uint256 value, uint256 new_root, bytes calldata op_proof) private view returns (bool)
    {
	bytes32[] memory proof_data = new bytes32[](5);
	proof_data[0] = bytes32(op);
	proof_data[1] = bytes32(uint256(uint160(msg.sender)));
	proof_data[2] = bytes32(value);
	proof_data[3] = bytes32(registry_root);
	proof_data[4] = bytes32(new_root);
	return single_op_verifier.verify(op_proof, proof_data);
    }

    // Submit batch proof
    function submit_batch_op(uint256 num_ops, uint256[MAX_OPS] calldata ops, address[MAX_OPS] calldata addresses, uint256[MAX_OPS] calldata values, uint256 new_root, bytes calldata op_proof) public returns (bool)
    {
	if(verify_batch_op(num_ops, ops, addresses, values, new_root, op_proof))
	    {
		registry_root = new_root;

		for(uint i = 0; i < num_ops; i++)
		    {
			emit smt_op(ops[i], addresses[i], values[i]);
		    }
		return true;
	    }

	return false;
    }
	

    // Verify batch proof
    function verify_batch_op(uint256 num_ops, uint256[MAX_OPS] calldata ops, address[MAX_OPS] calldata addresses, uint256[MAX_OPS] calldata values, uint256 new_root, bytes calldata op_proof) private view returns (bool)
    {
	bytes32[] memory proof_data = new bytes32[](3*(1 + MAX_OPS));
	proof_data[0] = bytes32(num_ops);
	for(uint256 i = 0; i < MAX_OPS; i++)
	    {
		proof_data[1 + i] = bytes32(ops[i]);
		proof_data[1 + MAX_OPS + i] = bytes32(uint256(uint160(addresses[i])));
		proof_data[1 + 2*MAX_OPS + i] = bytes32(values[i]);
	    }
	proof_data[1 + 3*MAX_OPS] = bytes32(registry_root);
	proof_data[2 + 3*MAX_OPS] = bytes32(new_root);
	
	return batch_op_verifier.verify(op_proof, proof_data);
    }
}
