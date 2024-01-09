// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 1e16; //0.01 ether
    address user = makeAddr("user");
    FundMe fundMe;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.deal(user, 10 ether);
        vm.startBroadcast(user);
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    // We have to fund the most recent deployed contract
    // To get the most recent deployed
    // foundry-devops package is used
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        console.log("mostRecentlyDeployed", mostRecentlyDeployed);
        fundFundMe(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        FundMe fundMeContract = FundMe(payable(mostRecentlyDeployed));
        address owner = fundMeContract.getOwner();
        uint256 fundMeBalance = mostRecentlyDeployed.balance;

        vm.startBroadcast(owner);
        fundMeContract.withdraw();
        vm.stopBroadcast();

        console.log("Owner Withdrawn %s", fundMeBalance);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
    }
}
