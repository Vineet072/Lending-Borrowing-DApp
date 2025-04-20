// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LendingBorrowing {
    mapping(address => uint256) public balances;
    uint256 public interestRate;

    constructor(uint256 _interestRate) {
        interestRate = _interestRate;
    }

    // Lend function
    function lend() external payable {
        balances[msg.sender] += msg.value;
    }

    // Borrow function
    function borrow(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient funds to borrow.");
        uint256 amountWithInterest = amount + (amount * interestRate) / 100;
        payable(msg.sender).transfer(amountWithInterest);
        balances[msg.sender] -= amount;
    }

    // View function to check balance
    function checkBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
