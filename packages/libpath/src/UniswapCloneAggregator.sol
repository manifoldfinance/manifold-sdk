pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import './interfaces/IUniswapClonePair.sol';
import './interfaces/IWETH.sol';
import './helpers/TransferHelper.sol';
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract UniswapCloneAggregator {
    using SafeMath for uint;

    struct PathNode {
        address token;
        address factory;
    }
    
    struct SupportedFactory {
        address factory;
        bytes initCodeHash;
    }

    mapping(address => SupportedFactory) public supportedFactories;
    address public immutable WETH;

    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'DXswapRouter: EXPIRED');
        _;
    }

    constructor(SupportedFactory[] memory _supportedFactories, address _WETH) public {
        for(uint _i = 0; _i < _supportedFactories.length; _i++) {
            SupportedFactory memory _supportedFactory = _supportedFactories[_i];
            supportedFactories[_supportedFactory.factory] = _supportedFactory;
        }
        WETH = _WETH;
    }

    receive() external payable {
        assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
    }

    function pairFor(PathNode memory inputNode, PathNode memory outputNode) internal view returns (address pair) {
        (address token0, address token1) = sortTokens(inputNode.token, outputNode.token);
        pair = address(uint(keccak256(abi.encodePacked(
            hex'ff',
            outputNode.factory,
            keccak256(abi.encodePacked(token0, token1)),
            supportedFactories[outputNode.factory].initCodeHash // init code hash
        ))));
    }

    function _swap(uint[] memory amounts, PathNode[] memory path, address _to) internal virtual {
        for (uint i; i < path.length - 1; i++) {
            (PathNode memory inputNode, PathNode memory outputNode) = (path[i], path[i + 1]);
            (address token0,) = sortTokens(inputNode.token, outputNode.token);
            uint amountOut = amounts[i + 1];
            (uint amount0Out, uint amount1Out) = inputNode.token == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
            address to = i < path.length - 2 ? pairFor(outputNode, path[i + 2]) : _to;
            IUniswapClonePair(pairFor(inputNode, outputNode)).swap(
                amount0Out, amount1Out, to, new bytes(0)
            );
        }
    }

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        PathNode[] calldata path,
        address to,
        uint deadline
    ) external virtual ensure(deadline) returns (uint[] memory amounts) {
        amounts = getAmountsOut(amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        TransferHelper.safeTransferFrom(
            path[0].token, msg.sender, pairFor(path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, to);
    }

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        PathNode[] calldata path,
        address to,
        uint deadline
    ) external virtual ensure(deadline) returns (uint[] memory amounts) {
        amounts = getAmountsIn(amountOut, path);
        require(amounts[0] <= amountInMax, 'DXswapRouter: EXCESSIVE_INPUT_AMOUNT');
        TransferHelper.safeTransferFrom(
            path[0].token, msg.sender, pairFor(path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, to);
    }

    function swapExactETHForTokens(uint amountOutMin, PathNode[] calldata path, address to, uint deadline)
        external
        virtual
       
        payable
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[0].token == WETH, 'DXswapRouter: INVALID_PATH');
        amounts = getAmountsOut(msg.value, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(pairFor(path[0], path[1]), amounts[0]));
        _swap(amounts, path, to);
    }

    function swapTokensForExactETH(uint amountOut, uint amountInMax, PathNode[] calldata path, address to, uint deadline)
        external
        virtual
       
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[path.length - 1].token == WETH, 'DXswapRouter: INVALID_PATH');
        amounts = getAmountsIn(amountOut, path);
        require(amounts[0] <= amountInMax, 'DXswapRouter: EXCESSIVE_INPUT_AMOUNT');
        TransferHelper.safeTransferFrom(
            path[0].token, msg.sender, pairFor(path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, PathNode[] calldata path, address to, uint deadline)
        external
        virtual
       
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[path.length - 1].token == WETH, 'DXswapRouter: INVALID_PATH');
        amounts = getAmountsOut(amountIn, path);
        require(amounts[amounts.length - 1] >= amountOutMin, 'DXswapRouter: INSUFFICIENT_OUTPUT_AMOUNT');
        TransferHelper.safeTransferFrom(
            path[0].token, msg.sender, pairFor(path[0], path[1]), amounts[0]
        );
        _swap(amounts, path, address(this));
        IWETH(WETH).withdraw(amounts[amounts.length - 1]);
        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
    }

    function swapETHForExactTokens(uint amountOut, PathNode[] calldata path, address to, uint deadline)
        external
        virtual
       
        payable
        ensure(deadline)
        returns (uint[] memory amounts)
    {
        require(path[0].token == WETH, 'DXswapRouter: INVALID_PATH');
        amounts = getAmountsIn(amountOut, path);
        require(amounts[0] <= msg.value, 'DXswapRouter: EXCESSIVE_INPUT_AMOUNT');
        IWETH(WETH).deposit{value: amounts[0]}();
        assert(IWETH(WETH).transfer(pairFor(path[0], path[1]), amounts[0]));
        _swap(amounts, path, to);
        // refund dust eth, if any
        if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
    }

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'DXswapLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'DXswapLibrary: ZERO_ADDRESS');
    }

    // fetches and sorts the reserves for a pair
    function getReserves(PathNode memory inputNode, PathNode memory outputNode) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(inputNode.token, outputNode.token);
        (uint reserve0, uint reserve1,) = IUniswapClonePair(pairFor(inputNode, outputNode)).getReserves();
        (reserveA, reserveB) = inputNode.token == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // fetches and sorts the reserves for a pair
    function getSwapFee(PathNode memory inputNode, PathNode memory outputNode) internal view returns (uint swapFee) {
        swapFee = IUniswapClonePair(pairFor(inputNode, outputNode)).swapFee();
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'DXswapLibrary: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'DXswapLibrary: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint swapFee) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'DXswapLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'DXswapLibrary: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(uint(10000).sub(swapFee));
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(10000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint swapFee) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'DXswapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'DXswapLibrary: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(10000);
        uint denominator = reserveOut.sub(amountOut).mul(uint(10000).sub(swapFee));
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(uint amountIn, PathNode[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'DXswapLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, getSwapFee(path[i], path[i + 1]));
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(uint amountOut, PathNode[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'DXswapLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, getSwapFee(path[i - 1], path[i]));
        }
    }
}
