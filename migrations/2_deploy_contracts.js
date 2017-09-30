var Experiment = artifacts.require("./Experiment.sol");

module.exports = function(deployer) {
  deployer.deploy(Experiment, 1000000, "Experiment-Coin", 2, "EXP" );
};
