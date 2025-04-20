const LendingBorrowing = artifacts.require("LendingBorrowing");

module.exports = function (deployer) {
  const interestRate = 10; // 10% interest rate
  deployer.deploy(LendingBorrowing, interestRate);
};
