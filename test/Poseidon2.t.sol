// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import {Poseidon2Harness} from "../contracts/Poseidon2harness.sol";

contract Poseidon2_test is Test {
    Poseidon2Harness internal h;

    uint256 internal constant PRIME =
        0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;

    function setUp() public {
        h = new Poseidon2Harness();
    }

    // ── FFI oracle ────────────────────────────────────────────────────────

    /// @dev Calls bb_out.cjs with an arbitrary number of inputs (already reduced mod PRIME).
    function _bb_hash(uint256[] memory inputs) internal returns (uint256) {
        // Build: "node --no-warnings bb_out.cjs a0 a1 ... 2>/dev/null"
        string memory args = "";
        for (uint256 i = 0; i < inputs.length; i++) {
            args = string(abi.encodePacked(args, i == 0 ? "" : " ", vm.toString(inputs[i])));
        }

        string[] memory cmd = new string[](3);
        cmd[0] = "/bin/sh";
        cmd[1] = "-c";
        cmd[2] = string(abi.encodePacked("node --no-warnings bb_out.cjs ", args, " 2>/dev/null"));

        bytes memory out = vm.ffi(cmd);
        require(out.length == 32, "FFI: expected 32 bytes");
        return uint256(bytes32(out));
    }

    /// @dev Reduce all inputs mod PRIME (matching Solidity's implicit addmod behaviour).
    function _r(uint256 x) internal pure returns (uint256) {
        return x % PRIME;
    }

    // Convenience wrappers so call-sites stay readable
    function _bb1(uint256 a) internal returns (uint256) {
        uint256[] memory v = new uint256[](1);
        v[0] = _r(a);
        return _bb_hash(v);
    }
    function _bb2(uint256 a, uint256 b) internal returns (uint256) {
        uint256[] memory v = new uint256[](2);
        v[0] = _r(a); v[1] = _r(b);
        return _bb_hash(v);
    }
    function _bb3(uint256 a, uint256 b, uint256 c) internal returns (uint256) {
        uint256[] memory v = new uint256[](3);
        v[0] = _r(a); v[1] = _r(b); v[2] = _r(c);
        return _bb_hash(v);
    }
    function _bb4(uint256 a, uint256 b, uint256 c, uint256 d) internal returns (uint256) {
        uint256[] memory v = new uint256[](4);
        v[0] = _r(a); v[1] = _r(b); v[2] = _r(c); v[3] = _r(d);
        return _bb_hash(v);
    }
    function _bb5(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e) internal returns (uint256) {
        uint256[] memory v = new uint256[](5);
        v[0] = _r(a); v[1] = _r(b); v[2] = _r(c); v[3] = _r(d); v[4] = _r(e);
        return _bb_hash(v);
    }
    function _bb6(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e, uint256 f) internal returns (uint256) {
        uint256[] memory v = new uint256[](6);
        v[0] = _r(a); v[1] = _r(b); v[2] = _r(c); v[3] = _r(d); v[4] = _r(e); v[5] = _r(f);
        return _bb_hash(v);
    }
    function _bb7(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e, uint256 f, uint256 g) internal returns (uint256) {
        uint256[] memory v = new uint256[](7);
        v[0] = _r(a); v[1] = _r(b); v[2] = _r(c); v[3] = _r(d); v[4] = _r(e); v[5] = _r(f); v[6] = _r(g);
        return _bb_hash(v);
    }
    function _bb8(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e, uint256 f, uint256 g, uint256 hh) internal returns (uint256) {
        uint256[] memory v = new uint256[](8);
        v[0] = _r(a); v[1] = _r(b); v[2] = _r(c); v[3] = _r(d);
        v[4] = _r(e); v[5] = _r(f); v[6] = _r(g); v[7] = _r(hh);
        return _bb_hash(v);
    }
    function _bb9(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e, uint256 f, uint256 g, uint256 hh, uint256 ii) internal returns (uint256) {
        uint256[] memory v = new uint256[](9);
        v[0] = _r(a); v[1] = _r(b); v[2] = _r(c); v[3] = _r(d);
        v[4] = _r(e); v[5] = _r(f); v[6] = _r(g); v[7] = _r(hh); v[8] = _r(ii);
        return _bb_hash(v);
    }

    // ── hash1 ─────────────────────────────────────────────────────────────

    function test_hash1_small_values() public {
        for (uint256 i = 0; i < 5; i++) {
            assertEq(h.hash1(i), _bb1(i), string.concat("hash1 mismatch i=", vm.toString(i)));
        }
    }

    function test_hash1_edge_cases() public {
        assertEq(h.hash1(0),                    _bb1(0));
        assertEq(h.hash1(1),                    _bb1(1));
        assertEq(h.hash1(PRIME - 1),            _bb1(PRIME - 1));
        assertEq(h.hash1(type(uint256).max),    _bb1(type(uint256).max));
    }

    // ── hash2 ─────────────────────────────────────────────────────────────

    function test_hash2_small_values() public {
        for (uint256 i = 1; i <= 5; i++) {
            assertEq(h.hash2(i, i * 2), _bb2(i, i * 2), string.concat("hash2 mismatch i=", vm.toString(i)));
        }
    }

    function test_hash2_edge_cases() public {
        assertEq(h.hash2(0, 0),         _bb2(0, 0));
        assertEq(h.hash2(1, 0),         _bb2(1, 0));
        assertEq(h.hash2(0, 1),         _bb2(0, 1));
        assertEq(h.hash2(PRIME - 1, 1), _bb2(PRIME - 1, 1));
    }

    // ── hash3 ─────────────────────────────────────────────────────────────

    function test_hash3_fixed_123() public view {
        assertEq(h.hash3(1, 2, 3), 0x23864adb160dddf590f1d3303683ebcb914f828e2635f6e85a32f0a1aecd3dd8);
    }

    function test_hash3_vectors() public {
        for (uint256 i = 1; i <= 10; i++) {
            uint256 a = i;
            uint256 b = i + 1000;
            uint256 c = i * 7 + 42;
            assertEq(h.hash3(a, b, c), _bb3(a, b, c), string.concat("hash3 mismatch i=", vm.toString(i)));
        }
    }

    function test_hash3_edge_cases() public {
        assertEq(h.hash3(0, 0, 0),               _bb3(0, 0, 0));
        assertEq(h.hash3(type(uint256).max, 0, 0), _bb3(type(uint256).max, 0, 0));
    }

    // ── hash4 (first multi-permutation case) ──────────────────────────────

    function test_hash4_vectors() public {
        for (uint256 i = 1; i <= 10; i++) {
            assertEq(
                h.hash4(i, i+1, i+2, i+3),
                _bb4(i, i+1, i+2, i+3),
                string.concat("hash4 mismatch i=", vm.toString(i))
            );
        }
    }

    function test_hash4_edge_cases() public {
        assertEq(h.hash4(0, 0, 0, 0),     _bb4(0, 0, 0, 0));
        assertEq(h.hash4(1, 0, 0, 0),     _bb4(1, 0, 0, 0));
        assertEq(h.hash4(0, 0, 0, 1),     _bb4(0, 0, 0, 1));
        assertEq(h.hash4(PRIME-1, PRIME-1, PRIME-1, PRIME-1),
                 _bb4(PRIME-1, PRIME-1, PRIME-1, PRIME-1));
    }

    // ── hash5 ─────────────────────────────────────────────────────────────

    function test_hash5_vectors() public {
        for (uint256 i = 1; i <= 10; i++) {
            assertEq(
                h.hash5(i, i+1, i+2, i+3, i+4),
                _bb5(i, i+1, i+2, i+3, i+4),
                string.concat("hash5 mismatch i=", vm.toString(i))
            );
        }
    }

    function test_hash5_edge_cases() public {
        assertEq(h.hash5(0, 0, 0, 0, 0), _bb5(0, 0, 0, 0, 0));
        assertEq(h.hash5(1, 2, 3, 4, 5), _bb5(1, 2, 3, 4, 5));
    }

    // ── hash6 ─────────────────────────────────────────────────────────────

    function test_hash6_vectors() public {
        for (uint256 i = 1; i <= 10; i++) {
            assertEq(
                h.hash6(i, i+1, i+2, i+3, i+4, i+5),
                _bb6(i, i+1, i+2, i+3, i+4, i+5),
                string.concat("hash6 mismatch i=", vm.toString(i))
            );
        }
    }

    function test_hash6_edge_cases() public {
        assertEq(h.hash6(0, 0, 0, 0, 0, 0), _bb6(0, 0, 0, 0, 0, 0));
        assertEq(h.hash6(1, 2, 3, 4, 5, 6), _bb6(1, 2, 3, 4, 5, 6));
    }

    // ── hash7 ─────────────────────────────────────────────────────────────

    function test_hash7_vectors() public {
        for (uint256 i = 1; i <= 10; i++) {
            assertEq(
                h.hash7(i, i+1, i+2, i+3, i+4, i+5, i+6),
                _bb7(i, i+1, i+2, i+3, i+4, i+5, i+6),
                string.concat("hash7 mismatch i=", vm.toString(i))
            );
        }
    }

    function test_hash7_edge_cases() public {
        assertEq(h.hash7(0,0,0,0,0,0,0), _bb7(0,0,0,0,0,0,0));
        assertEq(h.hash7(1,2,3,4,5,6,7), _bb7(1,2,3,4,5,6,7));
    }

    // ── hash8 ─────────────────────────────────────────────────────────────

    function test_hash8_vectors() public {
        for (uint256 i = 1; i <= 10; i++) {
            assertEq(
                h.hash8(i, i+1, i+2, i+3, i+4, i+5, i+6, i+7),
                _bb8(i, i+1, i+2, i+3, i+4, i+5, i+6, i+7),
                string.concat("hash8 mismatch i=", vm.toString(i))
            );
        }
    }

    function test_hash8_edge_cases() public {
        assertEq(h.hash8(0,0,0,0,0,0,0,0), _bb8(0,0,0,0,0,0,0,0));
        assertEq(h.hash8(1,2,3,4,5,6,7,8), _bb8(1,2,3,4,5,6,7,8));
    }

    // ── hash9 ─────────────────────────────────────────────────────────────

    function test_hash9_vectors() public {
        for (uint256 i = 1; i <= 10; i++) {
            assertEq(
                h.hash9(i, i+1, i+2, i+3, i+4, i+5, i+6, i+7, i+8),
                _bb9(i, i+1, i+2, i+3, i+4, i+5, i+6, i+7, i+8),
                string.concat("hash9 mismatch i=", vm.toString(i))
            );
        }
    }

    function test_hash9_edge_cases() public {
        assertEq(h.hash9(0,0,0,0,0,0,0,0,0), _bb9(0,0,0,0,0,0,0,0,0));
        assertEq(h.hash9(1,2,3,4,5,6,7,8,9), _bb9(1,2,3,4,5,6,7,8,9));
    }

    // ── Cross-arity sanity: different lengths must produce different hashes ─

    function test_different_lengths_differ() public {
        // hash1([1]) ≠ hash2([1,0]) ≠ hash3([1,0,0]) etc.
        // The sponge domain-separates by length, so these must all differ.
        uint256 h1 = h.hash1(1);
        uint256 h2 = h.hash2(1, 0);
        uint256 h3 = h.hash3(1, 0, 0);
        uint256 h4 = h.hash4(1, 0, 0, 0);
        uint256 h5 = h.hash5(1, 0, 0, 0, 0);

        assertTrue(h1 != h2, "hash1 == hash2");
        assertTrue(h2 != h3, "hash2 == hash3");
        assertTrue(h3 != h4, "hash3 == hash4");
        assertTrue(h4 != h5, "hash4 == hash5");
    }
}