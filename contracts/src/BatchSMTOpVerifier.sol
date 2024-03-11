// Verification Key Hash: 13f1f93cee8b11ab123c3e4a4bd7b2d2f7c880c2e20688b19929a497c24adf60
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import "./BaseUltraVerifier.sol";

library BatchSMTOpUltraVerificationKey {
    function verificationKeyHash() internal pure returns(bytes32) {
        return 0x13f1f93cee8b11ab123c3e4a4bd7b2d2f7c880c2e20688b19929a497c24adf60;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000001000000) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000021) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x0c9fabc7845d50d2852e2a0371c6441f145e0db82e8326961c25f1e3e32b045b) // vk.work_root
            mstore(add(_vk, 0x60), 0x30644e427ce32d4886b01bfe313ba1dba6db8b2045d128178a7164500e0a6c11) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x01e53ec531a957723c5834ea79305fab19a4b643ca9297dbec4606b8d6d514c4) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x1bea47f7269baab1c8725670cb2e75fa01081946ad5dea7ccf58f94b15355f85) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x25c831016571b395523bb00e7a6f982777bdf382066dd6f9e3b22b8d5304e286) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x23d89057d3aa8fd84a9ffb1f6198c6eb159f0bd57dc0fd7fddd8824f59a4d922) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x2ce0558e97a0629a870ed969c1e10f07e1dfc0fc63e4230df3a638f4bd1466f7) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x105eecd7c29808638a84ffec9831a320ded49068b408370b2f0f382502b48a32) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x01b075f823ec3f13da0d277e67eb65e82e2ff760e48e97ad74c44dedb51ff45a) // vk.Q4.x
            mstore(add(_vk, 0x160), 0x2426529f17df9a87f80a95b04cf68beff944687ffe28c5eeb306e3b8b9a8774f) // vk.Q4.y
            mstore(add(_vk, 0x180), 0x229b3de199a3512e22ba0fa7ff60f7d6c120ca63fb9381b5cc3e03e0aad7e45d) // vk.Q_M.x
            mstore(add(_vk, 0x1a0), 0x2e2d4901904b321f56620851a88750da9b3c6bc067fd4e061b7d1433e8e8c6b1) // vk.Q_M.y
            mstore(add(_vk, 0x1c0), 0x085aee6286b2bb148bb3bdf2a4596e08347e2b22651eb9b1b686c7f2aee1cbda) // vk.Q_C.x
            mstore(add(_vk, 0x1e0), 0x05426b6ae17584d99e12939228eeb71217190cac8569cf98993e12ebfd05a923) // vk.Q_C.y
            mstore(add(_vk, 0x200), 0x0168c4282c5160423458d44c3d6b589ffd3ce4cf8821343313fabb6f5fcedeb1) // vk.Q_ARITHMETIC.x
            mstore(add(_vk, 0x220), 0x276675d68cf899b38e3ae911f3525cb9709a1506e08afd8b5bb8734d8953d8b3) // vk.Q_ARITHMETIC.y
            mstore(add(_vk, 0x240), 0x26ccfc267355029a0fd3be7943e88ec6ad424915607550e344b908284588b533) // vk.QSORT.x
            mstore(add(_vk, 0x260), 0x06d2bc0c9ef24f0a3c5dfbf48f0121657f1eb0814c784ff025425d81251c8dc8) // vk.QSORT.y
            mstore(add(_vk, 0x280), 0x0fea19c8f64b37f784c03fe8a3673af34c1e74f7376b2ee5b0ef76b5a108df7f) // vk.Q_ELLIPTIC.x
            mstore(add(_vk, 0x2a0), 0x00e2134806764dc0644f60cbc757b0bf343400a5a369e69d50aa93be2ce4a029) // vk.Q_ELLIPTIC.y
            mstore(add(_vk, 0x2c0), 0x0bc2b032b47de292c5f97b14a04b9c366043003300018867ed963dc387b24ffd) // vk.Q_AUX.x
            mstore(add(_vk, 0x2e0), 0x27c7720149ca43e3b5a76143918b0bf20fc491a0caf720a7d563198d8ce1f8c9) // vk.Q_AUX.y
            mstore(add(_vk, 0x300), 0x11422901a20b6053a53202fe5237c4d8db625d6f149a939a17c6d1c90b69f699) // vk.SIGMA1.x
            mstore(add(_vk, 0x320), 0x17d587af68005721b8c8189f085d3f7bb3e92b1d6026ab1138b361f77f2d1629) // vk.SIGMA1.y
            mstore(add(_vk, 0x340), 0x1e10cfeebcdcb89486501d363dfca386dd029aebf0926b3373aefa2f684d6158) // vk.SIGMA2.x
            mstore(add(_vk, 0x360), 0x1a5c276526e9ea605d1a177c8f3d1b80e315bae2fdb68e77c11b11106ef70946) // vk.SIGMA2.y
            mstore(add(_vk, 0x380), 0x29339a60c414982c4069168b27314801ff2269b3893fd5229e1d105d1aa0e787) // vk.SIGMA3.x
            mstore(add(_vk, 0x3a0), 0x100cf3bbff21f24a3eef729e5b100d835295f311200684714bdc92bbe8ef267f) // vk.SIGMA3.y
            mstore(add(_vk, 0x3c0), 0x196a1b0fc9fc62d3dc1d3e6a11addcf74b5c2825554e54d20abfd34fcb89b0e0) // vk.SIGMA4.x
            mstore(add(_vk, 0x3e0), 0x23f9410d22a8d93fb98625e47a59be3b7c00daf40149d9e8de9fafb332776976) // vk.SIGMA4.y
            mstore(add(_vk, 0x400), 0x14dc82c8c78c83f1c925445f3982cab5cce99e92f465da863433d8eab1836fda) // vk.TABLE1.x
            mstore(add(_vk, 0x420), 0x1462e88a91b4833453eb44d4eb2aef70d16ffbe47e9ee822e34463757da9d3cf) // vk.TABLE1.y
            mstore(add(_vk, 0x440), 0x13d4cd96cf5430ae3dfd74269fb4090af8f0d06918bd691c2106295df086cf1f) // vk.TABLE2.x
            mstore(add(_vk, 0x460), 0x1a27c3ebe268296cd87c4b11ec0b4a6c3e9508037ad49a6c56f5b192386afb42) // vk.TABLE2.y
            mstore(add(_vk, 0x480), 0x0cfa7908b329ec95e99f785d964c8b9ddaeea9716ce6363eab844e0ab8000127) // vk.TABLE3.x
            mstore(add(_vk, 0x4a0), 0x24a1f8550258eff7a0920bf57b26c3d3f78bfa938c3a6085126356e91d46d2ff) // vk.TABLE3.y
            mstore(add(_vk, 0x4c0), 0x07fbed948a0d605ed35fdf0647b7092116c3603a410aaeafe166a16dde08ea05) // vk.TABLE4.x
            mstore(add(_vk, 0x4e0), 0x2cc1ded209b958f895ba6914e7f9c6bbd913ecc3661b573e365615fcb8b6eeb2) // vk.TABLE4.y
            mstore(add(_vk, 0x500), 0x27e9fe2000eeb30d53c1edd95b2d4fd548687d8db3d79be5fab159c520af1047) // vk.TABLE_TYPE.x
            mstore(add(_vk, 0x520), 0x295e101e63c776b655e833e718a130cdae022218d9fe3518f2b0cd09e6a80b2f) // vk.TABLE_TYPE.y
            mstore(add(_vk, 0x540), 0x039da515e7ea5881676b20fca28489a6acbfcf0834e4a3e944eedb95b4b2c1f8) // vk.ID1.x
            mstore(add(_vk, 0x560), 0x04771211a1b9e092fec308673fad2c62a023696129bf1eab619fb7b7b67f44d0) // vk.ID1.y
            mstore(add(_vk, 0x580), 0x1819478d40ab0f5649f9ea681bf749df453974139b30f777fb7458dbe7b5ee19) // vk.ID2.x
            mstore(add(_vk, 0x5a0), 0x1203f3142d2c42bc1708b50e7331aa87f8f5aa2f93cb1859255a950f507b50fc) // vk.ID2.y
            mstore(add(_vk, 0x5c0), 0x2f140a6b68004a550415f1f3b9b7b669da3aef4a3fefae9cc31ef6529e64cd57) // vk.ID3.x
            mstore(add(_vk, 0x5e0), 0x26e052b1e1366e75fb2f3885cbfb21f729e070944ab105ade2fc7a3df354d622) // vk.ID3.y
            mstore(add(_vk, 0x600), 0x2850322d65c6dd289d6dbf7998c6bad9a32994eb8ab47726deda48dcc80e8c91) // vk.ID4.x
            mstore(add(_vk, 0x620), 0x2c3044af1bceed797dbe29a0b46913c745d8263ad164afc2b421d860373083a3) // vk.ID4.y
            mstore(add(_vk, 0x640), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x660), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x680), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1 
            mstore(add(_vk, 0x6a0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0 
            mstore(add(_vk, 0x6c0), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1 
            mstore(add(_vk, 0x6e0), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0 
            mstore(_omegaInverseLoc, 0x2710c370db50e9cda334d3179cd061637be1488db323a16402e1d4d1110b737b) // vk.work_root_inverse
        }
    }
}

contract BatchSMTOpVerifier is BaseUltraVerifier {
    function getVerificationKeyHash() public pure override(BaseUltraVerifier) returns (bytes32) {
        return BatchSMTOpUltraVerificationKey.verificationKeyHash();
    }

    function loadVerificationKey(uint256 vk, uint256 _omegaInverseLoc) internal pure virtual override(BaseUltraVerifier) {
        BatchSMTOpUltraVerificationKey.loadVerificationKey(vk, _omegaInverseLoc);
    }
}
