// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract LiquidityInjector is Ownable, IERC721Receiver {
    INonfungiblePositionManager public immutable positionManager;
    address public token0;
    address public token1;
    uint24 public constant poolFee = 3000;

    struct Position {
        uint256 tokenId;
        uint128 liquidity;
    }
    
    mapping(uint256 => Position) public activePositions;

    constructor(address _pm, address _t0, address _t1) Ownable(msg.sender) {
        positionManager = INonfungiblePositionManager(_pm);
        token0 = _t0;
        token1 = _t1;
    }

    /**
     * @dev Mints a concentrated liquidity position to support the price.
     */
    function injectLiquidity(
        uint256 amount0,
        uint256 amount1,
        int24 tickLower,
        int24 tickUpper
    ) external onlyOwner returns (uint256 tokenId, uint128 liquidity) {
        IERC20(token0).transferFrom(msg.sender, address(this), amount0);
        IERC20(token1).transferFrom(msg.sender, address(this), amount1);

        IERC20(token0).approve(address(positionManager), amount0);
        IERC20(token1).approve(address(positionManager), amount1);

        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: token0,
            token1: token1,
            fee: poolFee,
            tickLower: tickLower,
            tickUpper: tickUpper,
            amount0Desired: amount0,
            amount1Desired: amount1,
            amount0Min: 0,
            amount1Min: 0,
            recipient: address(this),
            deadline: block.timestamp
        });

        (tokenId, liquidity, , ) = positionManager.mint(params);
        activePositions[tokenId] = Position(tokenId, liquidity);
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
