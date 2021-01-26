// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";
import '@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol';
import '@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol';
import "./interfaces/IMasterChef.sol";
import "./interfaces/IController.sol";
import "./interfaces/ICakePool.sol";
import "./interfaces/IPancakeSwapRouter.sol";
import "./interfaces/IUniswapV2Router02.sol";

contract CakePool is BEP20 {

    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;
    IBEP20 public token;
    
    IBEP20 public tokenMain;
    
    IMasterChef public masterchef;
    IController public controller;
    ICakePool public cakePool;

    IBEP20 public wbnb = IBEP20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    address public pancakeSwapRouter = address(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
    IUniswapV2Router02 public uniswapRouter;
    
    constructor(string memory _name, string memory _alias, IBEP20 _tokenMain, IBEP20 _token, IController _controller, IMasterChef _masterchef, ICakePool _cakePool) 
    BEP20(
        string(abi.encodePacked(_name, IBEP20(_token).name())),
        string(abi.encodePacked(_alias, IBEP20(_token).symbol()))
    )
    public {
        tokenMain = _tokenMain;
        token = _token;
        masterchef = _masterchef;
        controller = _controller;
        cakePool = _cakePool;
        uniswapRouter = IUniswapV2Router02(masterchef.router());
    }

    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    }

    function getReserves(address tokenA, address tokenB) public view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Router02(masterchef.tokenLP()).getReserves();
        (reserveA, reserveB) = address(tokenA) == address(token0) ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    function quote(uint amount, uint reserveA, uint reserveB) public view returns (uint) {
        return uniswapRouter.quote(amount, reserveB, reserveA);
    }    

    function tokensSend(uint valueWEI) public view returns(uint256){
        (uint reserveA, uint reserveB) = getReserves(address(masterchef.token()), address(wbnb));
        return uniswapRouter.quote(valueWEI, reserveB, reserveA);
    }  

    function _convertCakeToWBNB() internal {
        uint256 _amount = token.balanceOf(address(this));
        if(_amount > 0){
            token.safeApprove(pancakeSwapRouter, 0);
            token.safeApprove(pancakeSwapRouter, _amount);
            address[] memory path = new address[](2);
            path[0] = address(token);
            path[1] = address(wbnb);
            IPancakeSwapRouter(pancakeSwapRouter).swapExactTokensForTokens(_amount, uint256(0), path, address(this), now.add(1800));
        }
    }

    function _convertToken() internal {
        uint256 _amount = token.balanceOf(address(this));
        if(_amount > 0){
            _convertCakeToWBNB();
            uint256 amountWBNB = wbnb.balanceOf(address(this));
            uint256 tokens_solds = tokensSend(amountWBNB);
            controller.mint(address(this), tokens_solds);
            uint256 tokens_solds_min = tokens_solds.sub(tokens_solds.mul(3).div(100));
            uint256 value_min = amountWBNB.sub(amountWBNB.mul(3).div(100));
            tokenMain.safeApprove(address(uniswapRouter), tokens_solds);
            wbnb.safeApprove(address(uniswapRouter), amountWBNB);
            IPancakeSwapRouter(pancakeSwapRouter).addLiquidity(
                address(wbnb), // address tokenA WBNB,
                address(tokenMain), // address tokenMain,
                amountWBNB, // uint amountADesired,
                tokens_solds, // uint amountBDesired,
                tokens_solds_min, // uint amountAMin,
                value_min, // uint amountBMin,
                address(this), // address to,
                now.add(1800)// uint deadline
            );
        }
        compound();
    }

    function enterStaking(uint256 _amount) internal {
        token.safeApprove(address(cakePool), _amount);
        cakePool.enterStaking(_amount);
    }

    function compound() internal {
        uint256 amount = cakePool.pendingCake(0, address(this));
        token.safeApprove(address(cakePool), amount);
        cakePool.enterStaking(amount);
    }

    function deposit(uint256 _amount, address _ref) public {
        controller.registerMember(msg.sender, _ref);
        _mint(msg.sender, _amount);
        token.safeTransferFrom(address(msg.sender), address(this), _amount);
        compound();
        enterStaking(_amount);
        _convertToken();
    }

    function withdraw(uint256 _amount) public {
        require(balanceOf(msg.sender) >= _amount, "without balance");
        _burn(msg.sender, _amount);
        cakePool.leaveStaking(_amount);
        token.safeTransfer(msg.sender, _amount);
        _convertToken();
    }

    function emergencyWithdraw() onlyOwner public {
        cakePool.emergencyWithdraw(0);
    }

    function emergencyWithdrawUser() public {
        require(balanceOf(msg.sender) >= _amount, "without balance");
        _burn(msg.sender, _amount);
        token.safeTransfer(msg.sender, _amount);
    }    

    function pendingCake() external view returns (uint256) {
        return cakePool.pendingCake(0, address(this));
    }

}