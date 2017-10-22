var HumanStandardToken = artifacts.require("./HumanStandardToken.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");
module.exports = function(deployer) {
  var startTime = 1509563344;
  var endTime = 1511377744;
  var hardCap = 83334 * 10^18;
  var softCap = 8334 * 10^18;
  var beneficiary = "0xEa5bd9FD61954561EaE7E6890e44BFe5831fEBE7";
  var multiSig = "0x40DA434B0d32BD04896c6723E41E4c9840d36342";
  deployer.deploy(HumanStandardToken, 500000000, "DREAM", 18, "DREAM")
  .then(function () {
    return deployer.deploy(Crowdsale, HumanStandardToken.address, startTime, endTime, softCap, hardCap, beneficiary, multiSig)
  }).then(function() {
    console.log("Done deploying");
  });

};
