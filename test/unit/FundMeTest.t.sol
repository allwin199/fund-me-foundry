// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// FundMeTest.t.sol
// For foundry to identify a file as a test It should end with <contract>.t.sol

import {Test, console} from "forge-std/Test.sol";
// Forge Standard Library (Forge Std for short) is a collection of helpful contracts
// that make writing tests easier, faster, and more user-friendly.
// we get "vm" , "console" and many other cheat codes from "forge-std/Test.sol"
// We have to inherit "Test" inside this current contract to use all the above cheat codes

import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

// cutom errors
error FundMe__NOT_OWNER();
error FundMe__WITHDRAW_FAILED();
error FundMe__NOT_ENOUGH_ETH();

contract FundMeTest is Test {
    DeployFundMe deployer;
    FundMe fundMe;

    // whenver we are sending a tx, we need to simulate as if user is sending this tx
    // makeAddr() -> Creates an address derived from the provided name.
    address user = makeAddr("FUNDER");

    uint256 constant STARTING_BALANCE = 10e18;

    // Before testing the code we need the contract to be deployed
    // let's deploy with the help of deploy scripts
    // set up always run before any test suite
    function setUp() external {
        deployer = new DeployFundMe();
        fundMe = deployer.run();

        vm.deal(user, STARTING_BALANCE);
        // vm.deal() -> Sets the balance of an address who to newBalance.
        // we have create a dummy user and provided with 100e18
    }

    function test_MinimumUsd_Is_5() public {
        uint256 minimumUsd = fundMe.getMinimumUsd();
        uint256 requiredMinimumUsd = 5e18;
        assertEq(minimumUsd, requiredMinimumUsd);
    }

    function test_Owner_Is_Sender() public {
        address owner = fundMe.getOwner();
        assertEq(owner, msg.sender);
    }

    function test_PriceFeed_Version_Is_Accurate() public {
        uint256 requiredVersion = 4;
        uint256 currentVersion = fundMe.getVersion();
        assertEq(requiredVersion, currentVersion);
    }

    /////////////////////////////////////////////////////
    /////////////////////   Fund   //////////////////////
    /////////////////////////////////////////////////////
    function test_RevertIf_FundingAmount_Lessthan_MinimumUsd() public {
        // vm.expectRevert() -> Expects an revert on next line
        vm.expectRevert(abi.encodeWithSelector(FundMe__NOT_ENOUGH_ETH.selector));
        fundMe.fund();
        // To send a value to fund()
        // fundMe.fund{value: 1e18}()
        // since we are not sending any value
        // It should revert

        // To use expectRevert with a custom error type with parameters, ABI encode the error type.
    }

    function test_UserCan_FundWith_requiredUsd_UpdatesDS() public {
        // Arrange
        uint256 fundingAmount = 1e18;

        // Act
        vm.startPrank(user);
        fundMe.fund{value: fundingAmount}();
        vm.stopPrank();

        // Assert
        address latestFunder = fundMe.getFunder(0);
        assertEq(latestFunder, user);
        uint256 fundedAmount = fundMe.getAddressToAmountFunded(user);
        assertEq(fundedAmount, fundingAmount);
    }
}
