// Verification Key Hash: d037945cea095681aa64f804c8796ebf698bf547b255169983a7434508a56112
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import "./BaseUltraVerifier.sol";

library SingleSMTOpUltraVerificationKey {
    function verificationKeyHash() internal pure returns(bytes32) {
        return 0xd037945cea095681aa64f804c8796ebf698bf547b255169983a7434508a56112;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000200000) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000005) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x1ded8980ae2bdd1a4222150e8598fc8c58f50577ca5a5ce3b2c87885fcd0b523) // vk.work_root
            mstore(add(_vk, 0x60), 0x30644cefbebe09202b4ef7f3ff53a4511d70ff06da772cc3785d6b74e0536081) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x2078d8d0dc6494fcc984f3a5f5bfbaf078f6a302a889be52131611673a6526d2) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x2c7393194501a9437cf9589bd0edde63373b1840af37bf87a002743bc89c5a0e) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x264554a1976c5c33e581526adf91bdd6fe15450b12efb8e29239d2b3af0d57a3) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x11e665bb40fc1da2edc19d315620415c512eb4fb1878a1f5a45b0f55fb1be873) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x192f2c6018be6d581108d6997aa89d1799e2da44338b3cad606f621fc1480780) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x2b8adb2742031df2d0484eabf4309550a44f39df289def82fc08ceb079b7607a) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x0ac3b7c31d8bfa2249191f44b0eb2081e8cc08bceb2eb1907a77293c40360006) // vk.Q4.x
            mstore(add(_vk, 0x160), 0x0fd8ce3dd56fb2cdb7a226da73f2f9e056d2dc3d8e64769d97b5c7aede61abe6) // vk.Q4.y
            mstore(add(_vk, 0x180), 0x2484fd2084b82876e97bec4a9087dd68e2bf7816a2456c6f5e16ac0bbf11cc68) // vk.Q_M.x
            mstore(add(_vk, 0x1a0), 0x2ccd96e06bb038a2d6c966ca874d7b30390a4b61a360dbec3fd07041d38ce672) // vk.Q_M.y
            mstore(add(_vk, 0x1c0), 0x07ea9ea4ef36cc2d3ac3b9cac00623aaadb609eecf156440e1913e85f957e361) // vk.Q_C.x
            mstore(add(_vk, 0x1e0), 0x175bea7997e338b30018c863aeeb04390b87a8fbecc6f271b555da112bbfd9f8) // vk.Q_C.y
            mstore(add(_vk, 0x200), 0x266512da799226ddf080f14e610bc94e63113c3936f77dc2fb543a687837f3f1) // vk.Q_ARITHMETIC.x
            mstore(add(_vk, 0x220), 0x1afb7d591e985cb3a38516ddfe57abb078b011948906a0170cfab5f4a5212833) // vk.Q_ARITHMETIC.y
            mstore(add(_vk, 0x240), 0x1cb88190e2fe8e739ff1993b48b29ba4a482ea2e9d53e567eff9604efa058066) // vk.QSORT.x
            mstore(add(_vk, 0x260), 0x287e7a4a1be1e336102b89ac48df1a8139dad42fb9ecbc9cc25f515c9d5cf079) // vk.QSORT.y
            mstore(add(_vk, 0x280), 0x1b01c21b5e68590e37c4529b0d455171dd808ec6dbdb0947e42233f902e552aa) // vk.Q_ELLIPTIC.x
            mstore(add(_vk, 0x2a0), 0x2488e0934dab3854fbb692808a16d0caf847e4688e5e6b428d648880d8d5b6c7) // vk.Q_ELLIPTIC.y
            mstore(add(_vk, 0x2c0), 0x10900dec57dd3364ed873438a10709729d59c870792f6f0cccdf5a9dcc0c576a) // vk.Q_AUX.x
            mstore(add(_vk, 0x2e0), 0x0990a89afc070599b660f1fd20a822ddccfe2daf0de5d776fa6d9dec4857ced4) // vk.Q_AUX.y
            mstore(add(_vk, 0x300), 0x24fbab55ac3b61daacdf63090c4dcb7c886c6f69686a72da8bdd6564c7afdb18) // vk.SIGMA1.x
            mstore(add(_vk, 0x320), 0x0d8cee67a4b8dfc37edb5a0db51afac6be9a1cdbb2960dfde8c9d85cf64a70d4) // vk.SIGMA1.y
            mstore(add(_vk, 0x340), 0x0c41aff3dfd82f177d2aa8dd2b0e948d9be87f640f0b33810d6fa69d4a0b5f75) // vk.SIGMA2.x
            mstore(add(_vk, 0x360), 0x097a5e4bbebdf1f786396065d37df80a7d72db439c0c54fa528d3e87fa4fdc51) // vk.SIGMA2.y
            mstore(add(_vk, 0x380), 0x24bf562f1378cc8525bb64ae9b42dd7f358269a3206163a5f5d9846d16732ab3) // vk.SIGMA3.x
            mstore(add(_vk, 0x3a0), 0x04040d7f33db065494a1b2e1f86614987952931c8ee6eef39cd6161b01356e7c) // vk.SIGMA3.y
            mstore(add(_vk, 0x3c0), 0x0808045bf3e54d4ccd65b6be4036125d4a1c6da94aafc93a9d363cd3cb87d6f5) // vk.SIGMA4.x
            mstore(add(_vk, 0x3e0), 0x12e0d4d7f877249e10f6ab68eefc4263df6d609dd5c060544d3226ec818c1782) // vk.SIGMA4.y
            mstore(add(_vk, 0x400), 0x05479a425e2584d3e92bf613e1e1981bb6958b0a71d5fc150c028edcca928768) // vk.TABLE1.x
            mstore(add(_vk, 0x420), 0x0d5c6be83dc7204d94402e954bdc87db165bb783a1dd93f693840528ca28edfe) // vk.TABLE1.y
            mstore(add(_vk, 0x440), 0x007ca369d5db55667822dac70c8eaa28b766efa91a4951baa973629c5496599c) // vk.TABLE2.x
            mstore(add(_vk, 0x460), 0x203f49c2f5049d108b2d50348269d3ebe855073b85d64e163680c7a6dfcc99ca) // vk.TABLE2.y
            mstore(add(_vk, 0x480), 0x1851780f9c3919a1f0d9f7ced3f1be19d33f99c2a67e57bb749a21f7605393b3) // vk.TABLE3.x
            mstore(add(_vk, 0x4a0), 0x28d33495f84d57f7df3620f4c61216608c6bea403f1bd8760e84df35a5a93f1a) // vk.TABLE3.y
            mstore(add(_vk, 0x4c0), 0x0cb783bac7d576ee9430961c03835ec2b7f1e7713a14912ceacedcf4b4e22624) // vk.TABLE4.x
            mstore(add(_vk, 0x4e0), 0x288593094a6022d273994282ca268aa967d6b8bd68415da11d6af41669f2ffab) // vk.TABLE4.y
            mstore(add(_vk, 0x500), 0x06ca78377fe73e9c6ed6da6d86223509e304d689f80a23c9387c8441eadc41f3) // vk.TABLE_TYPE.x
            mstore(add(_vk, 0x520), 0x13b90adaaa0d6c5849e49ca68a13a1ebe47cbc36cc246b62124f3883eb5f69d1) // vk.TABLE_TYPE.y
            mstore(add(_vk, 0x540), 0x037839105d2c13f39c88bac3757348d207d6c7a87b6165b90e30f504001ba3af) // vk.ID1.x
            mstore(add(_vk, 0x560), 0x1bb2a533cd4ad3dfb251ca5bf8a03dbdb3ac4c5bafe39a7667e49876869bbec7) // vk.ID1.y
            mstore(add(_vk, 0x580), 0x288b8065d17ab595ce1995e4b44608a6b2139538d3c2926b69c4d2f4b46dcabb) // vk.ID2.x
            mstore(add(_vk, 0x5a0), 0x149df861480e38d3ab0186b2948d5d2551983e7e3efd7eb75e9936b8272615ee) // vk.ID2.y
            mstore(add(_vk, 0x5c0), 0x24bcb9ad0bd60e2dcd1d965d3a05abd625930527f4f85d2f3d6de4b63a68c7a4) // vk.ID3.x
            mstore(add(_vk, 0x5e0), 0x2d93980d3f28735156fac7df76e442836f544a5a1b3a065165b3699b50b93de7) // vk.ID3.y
            mstore(add(_vk, 0x600), 0x0d95d30f9de6988d3c0b7476ae36023b9a919c1d1c84fd600af672c40f943bc4) // vk.ID4.x
            mstore(add(_vk, 0x620), 0x0b261682973dda02970bc1ffa44309edc8c0c280d7c670cab4c150ed68c49887) // vk.ID4.y
            mstore(add(_vk, 0x640), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x660), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x680), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1 
            mstore(add(_vk, 0x6a0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0 
            mstore(add(_vk, 0x6c0), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1 
            mstore(add(_vk, 0x6e0), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0 
            mstore(_omegaInverseLoc, 0x19c6dfb841091b14ab14ecc1145f527850fd246e940797d3f5fac783a376d0f0) // vk.work_root_inverse
        }
    }
}

contract SingleSMTOpVerifier is BaseUltraVerifier {
    function getVerificationKeyHash() public pure override(BaseUltraVerifier) returns (bytes32) {
        return SingleSMTOpUltraVerificationKey.verificationKeyHash();
    }

    function loadVerificationKey(uint256 vk, uint256 _omegaInverseLoc) internal pure virtual override(BaseUltraVerifier) {
        SingleSMTOpUltraVerificationKey.loadVerificationKey(vk, _omegaInverseLoc);
    }
}
