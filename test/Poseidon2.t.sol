// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import {Poseidon2Harness} from "../contracts/Poseidon2harness.sol";

contract Poseidon2_test is Test {
    function test_hash3_matches_bb() public {
        Poseidon2Harness h = new Poseidon2Harness();

        uint256 got = h.hash3(1, 2, 3);
        uint256 expected =
            0x23864adb160dddf590f1d3303683ebcb914f828e2635f6e85a32f0a1aecd3dd8;

        assertEq(got, expected);
    }
}
