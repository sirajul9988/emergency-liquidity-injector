# Emergency Liquidity Injector

This repository implements an automated market-making strategy for DAO treasuries. Instead of just holding assets, the DAO uses its reserves to stabilize its own market during crashes.

## Core Strategy
1. **Trigger**: The `VolatilityOracle` (from Repo 41) signals "High Volatility."
2. **Rebalance**: The contract pulls the required pair (e.g., ETH/NativeToken) from the Treasury.
3. **Mint**: It calls the Uniswap V3 `NonfungiblePositionManager` to provide liquidity in a specific "Concentrated Range" around the current price.
4. **Remove**: Once volatility subsides, the DAO can withdraw the liquidity and return the assets (plus earned trading fees) to the Treasury.

## Technical Components
* **Concentrated Liquidity**: Focuses capital in a tight range (e.g., ±5%) to maximize the impact on the price floor.
* **NFT Management**: Tracks the Uniswap V3 LP NFT IDs for later removal or rebalancing.
