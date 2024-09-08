// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
}

contract SimpleDEX {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint public exchangeRate;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(address _tokenA, address _tokenB, uint _exchangeRate) {
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        exchangeRate = _exchangeRate;
    }

    function setExchangeRate(uint _newRate) external onlyOwner {
        exchangeRate = _newRate;
    }

    function exchangeTokenAForTokenB(uint amountA) external {
        require(amountA > 0, "Amount must be greater than zero");
        
        uint amountB = amountA * exchangeRate;
        require(tokenB.balanceOf(address(this)) >= amountB, "Not enough tokenB liquidity in contract");
        _transferTokens(tokenA, msg.sender, address(this), amountA);
        _transferTokens(tokenB, address(this), msg.sender, amountB);
    }

    function exchangeTokenBForTokenA(uint amountB) external {
        require(amountB > 0, "Amount must be greater than zero");
       
        uint amountA = amountB / exchangeRate; 
        require(tokenA.balanceOf(address(this)) >= amountA, "Not enough tokenA liquidity in contract");
        _transferTokens(tokenB, msg.sender, address(this), amountB);
        _transferTokens(tokenA, address(this), msg.sender, amountA);
    }
    
    function balanceOfTokenA(address account) external view returns (uint) {
        return tokenA.balanceOf(account);
    }

    function balanceOfTokenB(address account) external view returns (uint) {
        return tokenB.balanceOf(account);
    }

    // Internal function to handle token transfers
    function _transferTokens(IERC20 token, address from, address to, uint amount) internal {
        uint balanceBefore = token.balanceOf(to);
        
        bool success;
        if (from == address(this)) {
            success = token.transfer(to, amount);
        } else {
            success = token.transferFrom(from, to, amount);
        }
        
        require(success, "Token transfer failed");
        
        uint balanceAfter = token.balanceOf(to);
        require(balanceAfter - balanceBefore == amount, "Token transfer amount mismatch");
    }
}
