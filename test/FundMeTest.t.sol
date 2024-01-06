// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// FundMeTest.t.sol
// For foundry to identify a file as a test It should end with <contract>.t.sol

import {Test} from "forge-std/Test.sol";
// Forge Standard Library (Forge Std for short) is a collection of helpful contracts
// that make writing tests easier, faster, and more user-friendly.
// we get "vm" , "console" and many other cheat codes from "forge-std/Test.sol"
// We have to inherit "Test" inside this current contract to use all the above cheat codes

contract FundMeTest is Test {}
