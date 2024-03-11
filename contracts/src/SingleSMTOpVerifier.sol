// Verification Key Hash: fea7e415080581c6c5601095fa555186eda12c2e18b17da22d847bac64d3e005
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import "./BaseUltraVerifier.sol";

library SingleSMTOpUltraVerificationKey {
    function verificationKeyHash() internal pure returns(bytes32) {
        return 0xfea7e415080581c6c5601095fa555186eda12c2e18b17da22d847bac64d3e005;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000200000) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000005) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x1ded8980ae2bdd1a4222150e8598fc8c58f50577ca5a5ce3b2c87885fcd0b523) // vk.work_root
            mstore(add(_vk, 0x60), 0x30644cefbebe09202b4ef7f3ff53a4511d70ff06da772cc3785d6b74e0536081) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x198de84b3aaa22afb1f4819ab0357b6c3a73e9c82556e65e2bdfa2f7cfa50876) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x274753df4aad5f9fc4ed3f06e819e101617f0535d6600e2d3a5a99832f11bf5f) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x08bf6de136bc4d4bfd48736dc9325f49daae6c7775938dd9008a49dcfdbb2344) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x21cb97fe584920daafa58487a591618423ea63e15abf56add2b029fcbf7cdf23) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x1f226695096adf642775bd6df1d909db5a91fa198fcb5c65ec9c520734c85dd3) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x0c265e69799570007521262c2a8b16adf302e29eaa88d52ed2e4fef55b0d2a2b) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x132f866bd8b01e707f2e2d10b7528af3b0beba274acbecdd0c4e9d357191958c) // vk.Q4.x
            mstore(add(_vk, 0x160), 0x28c5b73d5c31ee9697db5f8e644972ee47b223c526e93c43160dfba692555f61) // vk.Q4.y
            mstore(add(_vk, 0x180), 0x18a805c20aea0eecc7dd2dad49b8198991286f1e9553c291d82c8d89f46a7a6e) // vk.Q_M.x
            mstore(add(_vk, 0x1a0), 0x184b7cf1de9798c33e8e5b73fa527e7f59ec7fa0f0939a90c82af8c3284fd016) // vk.Q_M.y
            mstore(add(_vk, 0x1c0), 0x26e189e17a5263ed4765ae156072d708b93f1adda41d930f40bf917a9c7d3743) // vk.Q_C.x
            mstore(add(_vk, 0x1e0), 0x1cf1b6ccc24ec6ebbc0fe952fb234cf3d9c89bc2b06bbb0df5bb655b7aecd60b) // vk.Q_C.y
            mstore(add(_vk, 0x200), 0x10e9fd8539cb7ab3b145925c4271b52db0b1d1dde634a3eb777c8a6406abdecf) // vk.Q_ARITHMETIC.x
            mstore(add(_vk, 0x220), 0x0fd6352d8626daffc96f3212509af7330c2de31f1ff4c903f7d8318e0b54a25b) // vk.Q_ARITHMETIC.y
            mstore(add(_vk, 0x240), 0x0cf2fd3d5b76eac4f7d90266d3cd9e652def3e14975af03b4d548e81a4cbb2f6) // vk.QSORT.x
            mstore(add(_vk, 0x260), 0x11b1c03c32c8b446217fafdaaf7f2ed48e4649054c99a154a10c58c4f71f3b6c) // vk.QSORT.y
            mstore(add(_vk, 0x280), 0x1b01c21b5e68590e37c4529b0d455171dd808ec6dbdb0947e42233f902e552aa) // vk.Q_ELLIPTIC.x
            mstore(add(_vk, 0x2a0), 0x2488e0934dab3854fbb692808a16d0caf847e4688e5e6b428d648880d8d5b6c7) // vk.Q_ELLIPTIC.y
            mstore(add(_vk, 0x2c0), 0x16a69c4b663d8b7cc1d5836adb8278cb259bc598c53c2b6dc6e3b8051770610c) // vk.Q_AUX.x
            mstore(add(_vk, 0x2e0), 0x10feb807d0bfae2f0f6890f47c17e99fc3038d196b419f7ef82d880af7cc40e6) // vk.Q_AUX.y
            mstore(add(_vk, 0x300), 0x2b4e47e9e934688bf939d582b9d3ce59e8c093ce428e4e340567dfb7237204d2) // vk.SIGMA1.x
            mstore(add(_vk, 0x320), 0x26975e236feb9e158024c922da2ba2496d314c9294305f6985301c229c084378) // vk.SIGMA1.y
            mstore(add(_vk, 0x340), 0x01f5674f72dcd9b62e7667226eb8b90ad7e67567b0f9c82d5d711ad6268462aa) // vk.SIGMA2.x
            mstore(add(_vk, 0x360), 0x12ad0aed117c8268b2d13868be7978612b0d08c6ff17690d5dfdd3b2e02a1b32) // vk.SIGMA2.y
            mstore(add(_vk, 0x380), 0x0ae9ad756a53678cb6cc943ece8b88572ad4207ee50a6039ee5864f96a3d45ff) // vk.SIGMA3.x
            mstore(add(_vk, 0x3a0), 0x0c4db39c93717c5595e7f07edbb3d3b35dea1059ba12aa0892a603e998b86bd9) // vk.SIGMA3.y
            mstore(add(_vk, 0x3c0), 0x18a953718a963d5cd7ffe5f359cd81400b81d5e17a27f69f2198c5383b803bc5) // vk.SIGMA4.x
            mstore(add(_vk, 0x3e0), 0x2063952215115f1779def1eaf6124211d523cdf140b4112bf5616d9b13d69d1f) // vk.SIGMA4.y
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
            mstore(add(_vk, 0x540), 0x226f81b5f45d7c79519a43b96d7a8dad09b742c22fa2567504f4ad3f4c859578) // vk.ID1.x
            mstore(add(_vk, 0x560), 0x273e9cbfce2a9b789df1f8c686bca7097e45def80e45a355fc6daaca5474d6ef) // vk.ID1.y
            mstore(add(_vk, 0x580), 0x26b2d572d371462cfca488fa17d76a91f046b004449e5d4ec6dd74004ce7742e) // vk.ID2.x
            mstore(add(_vk, 0x5a0), 0x04bdef8f2e79feb1e25b33b3e208bf1d2a5a0d6491c0561055d082fc139aa7cb) // vk.ID2.y
            mstore(add(_vk, 0x5c0), 0x04fc5dd0886769b7d0e6e0a7fb4f97a114a9f47a10c8dfdd0e64c85877d09482) // vk.ID3.x
            mstore(add(_vk, 0x5e0), 0x135b5b84b580dc1069432c93a6428359ddd1f060c0e3e7cf81c741ce042281e2) // vk.ID3.y
            mstore(add(_vk, 0x600), 0x18d731d7325dad0396917847a0e9ab9decaeeb36b455d3465d7024dfa1b5edd8) // vk.ID4.x
            mstore(add(_vk, 0x620), 0x2e6e796e1dbb895960b308ccfe2492102d8519fa654a7b60f12d16eeedd5c8c7) // vk.ID4.y
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
