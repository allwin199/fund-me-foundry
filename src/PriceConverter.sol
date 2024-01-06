// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// library is similar to a contract
//  but you can't declare any state variable and you can't send ether.
// A library is embedded into the contract if all library functions are internal.

library PriceConverter {
    // get the price for ETH/USD

    function getPrice(AggregatorV3Interface _priceFeed) internal view returns (uint256) {
        // To find the price of ETH/USD
        // we need that contact address and
        // ABI -> ABI exposes all the functions available in that contract
        // using this ABI, external contracts can interact with that contract
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306

        (, int256 price,,,) = _priceFeed.latestRoundData();

        // Note
        // this price will give the Price of ETH in terms of USD
        // price will have 8 deciaml places
        // msg.value will be in terms of WEI which means 18 decimal places
        // to matchup price and msg.value we have to convert price to 18 deciamls
        // price has already 8 decimal places we have to add another 10 decimals
        // price * 1e10 will convert price into 18 decimals
        // price is int and msg.value is uint
        // let's convert everything into uint256

        return uint256(price * 1e10);

        // Now this getPrice() will return price of 1 ETH in terms of USD
    }

    // get the conversion rate
    // If msg.value = 0.1 ETH then what is the value in USD?

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface _priceFeed) internal view returns (uint256) {
        // this getConversionRate will get msg.value and ethPrice can be obtained from getPrice()

        // step1
        // get the price of ETH using getPrice()
        uint256 ethPrice = getPrice(_priceFeed);

        // if msg.value is 1 ETH then 1e18*return val of getPrice()
        // for eg return value of getPrice() is 2000e18
        // then 1e18 * 2000e18 = 2000e36
        // since we need only 18 decimals we have to divide it by 18
        // 2000e36/1e18 = 2000e18
        // if msg.value is 0.5 ETH
        // then 0.5e18 * 2000e18 = 1000e36
        // 1000e36/1e18 = 1000e18

        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18;

        // let's say ethAmount is 0.5e18
        // ethPrice = 2000e18
        // ethAmountInUsd = (0.5e18 * 2000e18)/1e18
        // ethAmountInusd = 1000e18

        return ethAmountInUsd;
    }
}
