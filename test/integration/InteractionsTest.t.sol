// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    DeployFundMe deployer;
    FundMe fundMe;
    FundFundMe fundFundMe;

    function setUp() external {
        deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function test_UserCanFund_UsingInteractions() public {
        // Instead of funding using fundMe.fund()
        // We are funding using interactions scripts
        fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        assertGt(address(fundMe).balance, 0);
    }

    function test_OwnerCanWithdraw_UsingInteractions() public {
        fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        assertEq(address(fundMe).balance, 0);
    }
}
