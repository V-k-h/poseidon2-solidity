// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Poseidon2T4} from "./Poseidon2T4.sol";

contract Poseidon2Harness {
    function hash1(uint256 a0) external pure returns (uint256) {
        return Poseidon2T4.hash1(a0);
    }
    function hash2(uint256 a0, uint256 a1) external pure returns (uint256) {
        return Poseidon2T4.hash2(a0, a1);
    }
    function hash3(uint256 a0, uint256 a1, uint256 a2) external pure returns (uint256) {
        return Poseidon2T4.hash3(a0, a1, a2);
    }
    function hash4(uint256 a0, uint256 a1, uint256 a2, uint256 a3) external pure returns (uint256) {
        return Poseidon2T4.hash4(a0, a1, a2, a3);
    }
    function hash5(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4) external pure returns (uint256) {
        return Poseidon2T4.hash5(a0, a1, a2, a3, a4);
    }
    function hash6(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4, uint256 a5) external pure returns (uint256) {
        return Poseidon2T4.hash6(a0, a1, a2, a3, a4, a5);
    }
    function hash7(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4, uint256 a5, uint256 a6) external pure returns (uint256) {
        return Poseidon2T4.hash7(a0, a1, a2, a3, a4, a5, a6);
    }
    function hash8(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4, uint256 a5, uint256 a6, uint256 a7) external pure returns (uint256) {
        return Poseidon2T4.hash8(a0, a1, a2, a3, a4, a5, a6, a7);
    }
    function hash9(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4, uint256 a5, uint256 a6, uint256 a7, uint256 a8) external pure returns (uint256) {
        return Poseidon2T4.hash9(a0, a1, a2, a3, a4, a5, a6, a7, a8);
    }
    function perm(uint256[4] calldata x) external pure returns (uint256[4] memory) {
        return Poseidon2T4.permutation(x);
    }
}