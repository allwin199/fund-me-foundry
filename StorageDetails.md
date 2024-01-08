# Stroage Details

```sh
forge inspect <contract> storageLayout
```

```sh
forge inspect FundMe storageLayout
```

```json
{
    "storage": [
        {
            "astId": 44901,
            "contract": "src/FundMe.sol:FundMe",
            "label": "s_funders",
            "offset": 0,
            "slot": "0",
            "type": "t_array(t_address)dyn_storage"
        },
        {
            "astId": 44905,
            "contract": "src/FundMe.sol:FundMe",
            "label": "s_addressToAmountFunded",
            "offset": 0,
            "slot": "1",
            "type": "t_mapping(t_address,t_uint256)"
        }
    ]
}
```

-   Once the contract is deployed, to inspect storage

```sh
cast storage <deployedAddress>
```

```sh
cast storage <deployedAddress> <storage_slot>
```
