const ExpenseManagerContract = artifacts.require("ExpenseManagerContract");


module.exports = function (deployer) {
    deployer.deploy(ExpenseManagerContract);
};