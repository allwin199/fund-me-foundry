# Interactions

    -   We have to fund the most recent deployed contract
    -   To get the most recent deployed
    -   foundry-devops package is used

## Installation

```sh
forge install Cyfrin/foundry-devops --no-commit
```

## Usage

1. Update `foundry.toml` to have read permissions on the broadcast folder.

```sh
fs_permissions = [{ access = "read", path = "./broadcast" }]
```

2. Import the package, and call `DevOpsTools.get_most_recent_deployment("MyContract", chainid)`;

```solidity
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MyContract} from "my-contract/MyContract.sol";
.
.
.
function interactWithPreviouslyDeployedContracts() public {
    address contractAddress = DevOpsTools.get_most_recent_deployment("MyContract", block.chainid);
    MyContract myContract = MyContract(contractAddress);
    myContract.doSomething();
}
```
