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
    uint256 constant FUNDING_AMOUNT = 1e18;

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

    modifier fundingRequiredUsd() {
        // Act
        vm.startPrank(user);
        fundMe.fund{value: FUNDING_AMOUNT}();
        vm.stopPrank();
        _;
    }
    // By creating a funding modifier this can be plugged to any function

    function test_Funding_Updates_Mapping() public fundingRequiredUsd {
        // Assert
        uint256 fundedAmount = fundMe.getAddressToAmountFunded(user);
        assertEq(fundedAmount, FUNDING_AMOUNT);
    }

    function test_Funding_Updates_Array() public fundingRequiredUsd {
        // Assert
        address latestFunder = fundMe.getFunder(0);
        assertEq(latestFunder, user);
    }

    /////////////////////////////////////////////////////
    /////////////////   Withdraw   //////////////////////
    /////////////////////////////////////////////////////

    function test_RevertIf_Withdraw_NotCalledBy_Owner() public fundingRequiredUsd {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function test_Owner_CanWithdraw() public fundingRequiredUsd {
        // Arrange
        address owner = fundMe.getOwner();
        uint256 startingOwnerBalance = owner.balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(owner); // we are pranking as owner
        fundMe.withdraw();

        uint256 endingOwnerBalance = owner.balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        // Assert
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
        assertEq(endingFundMeBalance, 0);
    }

    function test_Owner_CanWithdraw_AfterMutiple_Funding() public fundingRequiredUsd {
        // To simulate funding with more people
        // hoax can be used
        // hoax -> Sets up a prank from an address that has some ether.
        // hoax is a combination of
        // makeAddr()
        // vm.deal()
        // vm.prank();
        // by using hoax above 3 functionalities can be used

        // To generate a address we can do address(1) or address(2) ....
        // but only constraint is number inside address() should be uint160
        // sometimes address(0) might revert, tried avoiding it

        uint256 numberOfFunders = 10;
        for (uint160 funder = 1; funder < numberOfFunders; funder++) {
            hoax(address(funder), STARTING_BALANCE);
            fundMe.fund{value: FUNDING_AMOUNT}();
        }

        address owner = fundMe.getOwner();
        uint256 startingOwnerBalance = owner.balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(owner);
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = owner.balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        // Assert
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
        assertEq(endingFundMeBalance, 0);
    }
}
