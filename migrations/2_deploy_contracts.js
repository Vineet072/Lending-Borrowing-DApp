const LendingBorrowing = artifacts.require("LendingBorrowing");

module.exports = function (deployer) {
  const interestRate = 10;
  deployer.deploy(LendingBorrowing, interestRate);
};
