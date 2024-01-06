// Todo
// 1. Deploy mock priceFeed contract when we are on a local anvil chain
// 2. Keep track of contract addresses across different chains
// - Sepolia ETH/USD
// - ETH Mainnet ETH/USD
// - Anvil ETH/USD

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on a local anvil, we deploy mocks
    // Otherwise, grab the existing address from the live network

    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIAMLS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else if (block.chainid == 31337) {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    // With the different priceFeed address we can get ETH/USD price while working on ETH Mainnet
    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainnetConfig;
    }

    // while working with Anvil config
    // 1. We need to deploy mock priceFeed contract
    // 2. Return the mock addresses
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        // whenever a address is defined in a struct
        // address will be initialized to address(0)
        // If already chain id is detected then activeNetworkConfig will have different address than address(0)

        // If it is address(0)
        // then we deploy the mocks

        // The reason we are doing conditions above is
        // If we don't have the above condition
        // Everytime when getAnvilEthConfig() is called
        // mocks will be deployed
        // since we have conditions to check
        // If mocks are already deployed then address will not be address(0)

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIAMLS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockV3Aggregator)});
        return anvilConfig;
    }
}
