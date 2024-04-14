// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/OffchainRegistry.sol";

contract OffchainRegistryScript is Script
{
    function setUp() public
    {}

    function run() public
    {
	uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
	
	vm.startBroadcast(deployerPrivateKey);

	BatchSMTOpVerifier batch_op_verifier = new BatchSMTOpVerifier();
	SingleSMTOpVerifier single_op_verifier = new SingleSMTOpVerifier();
	OffchainRegistry offchain_registry = new OffchainRegistry(0, batch_op_verifier, single_op_verifier);

	vm.stopBroadcast();

	console.log("Offchain registry address: %s", address(offchain_registry));
	
    }
}
