// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// FundMeTest.t.sol
// For foundry to identify a file as a test It should end with <contract>.t.sol

import {Test, console} from "forge-std/Test.sol";
// Forge Standard Library (Forge Std for short) is a collection of helpful contracts
// that make writing tests easier, faster, and more user-friendly.
// we get "vm" , "console" and many other cheat codes from "forge-std/Test.sol"
// We have to inherit "Test" inside this current contract to use all the above cheat codes

import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    DeployFundMe deployer;
    FundMe fundMe;

    // Before testing the code we need the contract to be deployed
    // let's deploy with the help of deploy scripts
    // set up always run before any test suite
    function setUp() external {
        deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function test_MinimumUsd_Is_5() public {
        uint256 minimumUsd = fundMe.MINIMUM_USD();
        uint256 requiredMinimumUsd = 5e18;
        assertEq(minimumUsd, requiredMinimumUsd);
    }

    function test_Owner_Is_Sender() public {
        address owner = fundMe.i_owner();
        assertEq(owner, msg.sender);
    }

    function test_PriceFeed_Version_Is_Accurate() public {
        uint256 requiredVersion = 4;
        uint256 currentVersion = fundMe.getVersion();
        assertEq(requiredVersion, currentVersion);
    }
}
