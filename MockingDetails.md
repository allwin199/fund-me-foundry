# Mocking

-   For ETH/USD we have a priceFeed address that works on Sepolia chain
-   But everytime we cannot test on the fork-url
-   Instead we need some setup for local testing

## Local Setup

-   To test this locally we can deploy a mock contract to anvil chain which gives the price of ETH/USD
-   We use helper config inside the scripts to deploy mocks when working with local chain
-   Mock contract is already present in the chainlink-brownie-library
-   We can deploy this mock and get the priceFeed address
