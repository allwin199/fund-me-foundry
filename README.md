# Foundry Fund Me

## Quickstart

```sh
git clone https://github.com/worksofallwin/foundry-fund-me-v3.git
cd foundry-fund-me-v3
forge build
```

# Usage

## Anvil

- Spin up the anvil chain

```sh
anvil
```

- To load .env in terminal

```sh
source .env
```

Deploy:

```sh
forge script scripts/DeployFundMe.s.sol
```

## Testing

```sh
forge test
```

or

- Only run test functions matching the specified regex pattern.

```sh
forge test --match-test testFunctionName
```

or

- To fork Sepolia chain

```sh
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```sh
forge coverage
```

# Deployment to a testnet or mainnet

1. Setup environment variables

You'll want to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file.

-   `PRIVATE_KEY`: The private key of your account (like from [metamask](https://metamask.io/)). **NOTE:** FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
    -   You can [learn how to export it here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
-   `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://alchemy.com/?a=673c802981)

Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

1. Get testnet ETH

Head over to [faucets.chain.link](https://faucets.chain.link/) and get some tesnet ETH. You should see the ETH show up in your metamask.

2. Deploy

- To deploy the smart contract with encrypting private key

[Encryption](https://github.com/allwin199/foundry-fundamendals/blob/main/DeploymentDetails.md)

```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --account <account_name> --sender <address> --broadcast
```

## Scripts

After deploying to a testnet or local net, you can run the scripts.

Using cast deployed locally example:

```sh
forge script script/Interactions.s.sol:FundFundMe --rpc-url $SEPOLIA_RPC_URL --account <account_name> --sender <address> --broadcast
```

### Withdraw

```sh
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $SEPOLIA_RPC_URL --account <account_name> --sender <address> --broadcast
```

## Estimate gas

You can estimate how much gas things cost by running:

```sh
forge snapshot
```

And you'll see and output file called `.gas-snapshot`

# Formatting

To run code formatting:

```sh
forge fmt
```

# Thank you!
