-include .env

.PHONY:  test deploy fund snapshot format anvil deployToAnvil deployToSepolia fundAnvilContract withdrawAnvilContract
# .phoney describes all the command are not directories

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deployToAnvil:
	@forge script script/DeployFundMe.s.sol --rpc-url $(ANVIL_RPC_URL) --account $(ACCOUNT_FOR_ANVIL) --sender $(ANVIL_KEYCHAIN) --broadcast

deployToSepolia:
	@forge script script/DeployFundMe.s.sol --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT_FOR_SEPOLIA) --sender $(SEPOLIA_KEYCHAIN) --broadcast --verify $(ETHERSCAN_API_KEY)

fundAnvilContract:
	@forge script script/Interactions.s.sol:FundFundMe --rpc-url $(ANVIL_RPC_URL) --account $(ACCOUNT_FOR_ANVIL) --sender $(ANVIL_KEYCHAIN) --broadcast

withdrawAnvilContract:
	@forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $(ANVIL_RPC_URL) --account $(ACCOUNT_FOR_ANVIL) --sender $(ANVIL_KEYCHAIN) --broadcast


# To deploy the Contract
# make deployToSepolia or make deployToAnvil

# To interact with the contract
# make fundAnvilContract
# make withdrawAnvilContract