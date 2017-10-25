var Crowdsale = artifacts.require("./Crowdsale.sol");
var utils = require('./helpers/Utils');
var Token = artifacts.require('./HumanStandardToken.sol')

contract('Crowdsale', function(accounts, a) {
  console.log();

  var currentTime = Date.now()
  var startTime = currentTime + 20000;
  var endTime = startTime + 400000;
  var beneficiary = accounts[1];
  var wallet = accounts[2];
  var softCap = web3.toWei(5, 'ether');
  var hardCap = web3.toWei(2000, 'ether');

  it('Throws exception if start time is lesser than current time', async () => {

    var startTime = currentTime - 40000;
    var endTime = currentTime + 50000;


    try {
      await Crowdsale.new(accounts[3], startTime, endTime, softCap, hardCap, beneficiary, wallet, {from : accounts[0] });
    } catch(e) {
      utils.ensureException(e);
    }
  })

  it('Throws exception if softcap is less than zero', async () => {
    try {
      var softCap = -10;
      await Crowdsale.new(accounts[3], startTime, endTime, softCap, hardCap, beneficiary, wallet, {from : accounts[0] });
    } catch(e) {
      utils.ensureException(e);
    }
  })

  it('hardCap must be greater than the softCap', async () => {
    await Crowdsale.new(accounts[3], startTime, endTime, softCap, hardCap, beneficiary, wallet, {from : accounts[0] });
  })

  it('throws exception if multisig wallet address is zero address', async () => {
    var wallet = utils.zeroAddress;
    try {
      await Crowdsale.new(accounts[3], startTime, endTime, softCap, hardCap, beneficiary, wallet, {from : accounts[0] });
    } catch(e) {
      utils.ensureException(e);
    }
  })

  it('throws exception if beneficiary wallet address is zero address', async () => {
    var beneficiary = utils.zeroAddress;
    try {
      await Crowdsale.new(accounts[3], startTime, endTime, softCap, hardCap, beneficiary, wallet, {from : accounts[0] });
    } catch(e) {
      utils.ensureException(e);
    }
  })

  // it('throws exception if the ethers are sent when the crowdsale is not in operation', async () => {
  //   let totalCoins = web3.toWei(1, 'ether');
  //   let token = await Token.new(totalCoins, 'TEST', 18, 'TXT', {from : accounts[0]})
  //   let crowdsale = await Crowdsale.new(token.address, startTime, endTime, softCap, hardCap, accounts[0], wallet, { from : accounts[0] });
  //   let tokenApproveTx = await token.approve(crowdsale.address, totalCoins , {from: accounts[0]});
  //   let tx = await crowdsale.contribute({from: accounts[1], value: web3.toWei(0.8, 'ether' )})
  //   //
  //   // let t = await crowdsale.getContributionAmount(accounts[1], {from : accounts[0]})
  //
  //   let tokenBalance = await token.balanceOf(accounts[1], {from : accounts[0] });
  //   let beneficiaryTokenBalance = await token.balanceOf(accounts[0]);
  //   console.log(tokenBalance.toString(), beneficiaryTokenBalance.toString(), crowdsale.address);
  //
  //
  // })

});
