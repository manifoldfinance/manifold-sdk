pragma solidity >=0.6.6;

interface IUniswapClonePair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function swapFee() external view returns (uint32);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}