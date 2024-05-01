// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Interface for ERC20 tokens that will be deposited to the wallet contract
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract MultiTokenWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    // Receive function to accept ETH deposits
    receive() external payable {}

    //this function transfer eth to other wallets by owner of the wallet
    function transfer(address payable to, uint256 amount) public onlyOwner {
        require(to != address(0), "Invalid recipient address");
        require(amount <= address(this).balance, "Insufficient ETH balance");

        to.transfer(amount);
    }

    function transferToken(address tokenAddress, address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Invalid recipient address");
        
        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(owner, to, amount), "Token transfer failed");
    }

    function approveTokenTransfer(address tokenAddress, address spender, uint256 amount) public onlyOwner {
        require(spender != address(0), "Invalid spender address");

        IERC20 token = IERC20(tokenAddress);
        require(token.approve(spender, amount), "Token approval failed");
    }
   //gets balances of erc20 tokens in the contract
    function checkTokenBalance(address tokenAddress) public view returns (uint256) {
        IERC20 token = IERC20(tokenAddress);
        return token.balanceOf(address(this));
    }
    //get eth balance of contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
