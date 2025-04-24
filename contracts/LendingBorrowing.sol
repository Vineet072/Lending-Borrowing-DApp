// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LendingBorrowing {
    address public owner;
    uint256 public interestRate;
    uint256 public totalPool;

    struct Loan {
        uint256 amount;
        uint256 due;
        bool isActive;
    }

    mapping(address => uint256) public lenderDeposits;
    mapping(address => Loan) public borrowerLoans;

    constructor(uint256 _interestRate) {
        owner = msg.sender;
        interestRate = _interestRate;
    }

    // Lend ETH to the pool
    function lend() external payable {
        require(msg.value > 0, "Must send ETH to lend.");
        lenderDeposits[msg.sender] += msg.value;
        totalPool += msg.value;
    }

    // Borrow ETH from the pool
    function borrow(uint256 amount) external {
        require(amount > 0, "Borrow amount must be > 0.");
        require(totalPool >= amount, "Not enough liquidity in pool.");
        require(!borrowerLoans[msg.sender].isActive, "Already have an active loan.");

        uint256 dueAmount = amount + (amount * interestRate) / 100;

        borrowerLoans[msg.sender] = Loan({
            amount: amount,
            due: dueAmount,
            isActive: true
        });

        totalPool -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Repay loan
    function repay() external payable {
        Loan storage loan = borrowerLoans[msg.sender];
        require(loan.isActive, "No active loan.");
        require(msg.value >= loan.due, "Insufficient repayment.");

        totalPool += msg.value;
        loan.isActive = false;
    }

    // View if borrower has a loan
    function hasActiveLoan(address user) external view returns (bool) {
        return borrowerLoans[user].isActive;
    }

    // Check what a user owes
    function getDueAmount(address user) external view returns (uint256) {
        require(borrowerLoans[user].isActive, "No active loan.");
        return borrowerLoans[user].due;
    }

    // Check pool balance
    function getPoolBalance() external view returns (uint256) {
        return totalPool;
    }
}
