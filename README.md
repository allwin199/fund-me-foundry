# Foundry Fund Me

## Quickstart

```sh
git clone https://github.com/worksofallwin/foundry-fund-me-v3.git
cd foundry-fund-me-v3
forge build
```

# Usage

## Anvil

-   Spin up the anvil chain

```sh
anvil
```

-   To load .env in terminal

```sh
source .env
```

Deploy:

This will default to your local node. You need to have it running in another terminal in order for it to deploy.

```sh
make deployToAnvil
```

## Testing

```sh
forge test
```

or

-   Only run test functions matching the specified regex pattern.

```sh
forge test --mt testFunctionName
```

or

-   To fork Sepolia chain

```sh
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```sh
forge coverage
```

# Deployment to a testnet or mainnet

1. Setup environment variables

-   You'll want to set your `SEPOLIA_RPC_URL` in environment variables. You can add them to a `.env` file.

-   `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://alchemy.com/?a=673c802981)

-   Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

2. Use wallet options to Encrypt Private Keys

-   To deploy the smart contract with encrypting private key

-   [Private Key Encryption](https://github.com/allwin199/foundry-fundamendals/blob/main/DeploymentDetails.md)

```sh
make deployToSepolia
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
