var Crowdsale = artifacts.require("./Crowdsale.sol");
var utils = require('./helpers/Utils');
var Token = artifacts.require('./HumanStandardToken.sol')

contract('Crowdsale', async (accounts, a) => {
  var currentTime = Date.now()
  var startTime = currentTime + 20000;
  var endTime = 14;
  var beneficiary = accounts[0];
  var wallet = accounts[2];
  var softCap = web3.toWei(5, 'ether');
  var hardCap = web3.toWei(2000, 'ether');

  it('Throws exception if start time is lesser than current time', async () => {

    var startTime = currentTime - 40000;


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
    let startTime = Date.now();
    await Crowdsale.new(accounts[3], startTime, endTime, softCap, softCap + 10, beneficiary, wallet, {from : accounts[0] });
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
  it('it should not accept contributions if the crowdsale is not in operation', async () => {
    let totalCoins = web3.toWei(500, 'ether');
    let token = await Token.new(totalCoins, 'TEST', 18, 'TXT', {from : accounts[0]})
    let crowdsale = await Crowdsale.new(token.address, startTime + 10000, endTime, softCap, hardCap, accounts[0], wallet, { from : accounts[0] });
    await token.approve(crowdsale.address, 4000 , {from: accounts[0]});
    try {
      await crowdsale.contribute({ from : accounts[1] , value : web3.toWei(0.8, 'ether') })
    } catch(e) {
      utils.ensureException(e);
    }
  });

  it('It should transfer 2000 tokens for 1 eth', async () => {
    let totalCoins = web3.toWei(500000, 'ether');
    let token = await Token.new(totalCoins, 'TEST', 18, 'TXT', {from : accounts[0]})
    let crowdsale = await Crowdsale.new(token.address, Date.now() / 1000 , endTime, softCap, hardCap, accounts[0], wallet, { from : accounts[0] });
    await token.approve(crowdsale.address, totalCoins, { from: accounts[0] });
    let contribution = await crowdsale.contribute({ value: web3.toWei(1, "ether"),  from : accounts[1] });
    let tokenBalance = await token.balanceOf(accounts[1]);
    assert (tokenBalance.toString() === '2000')
  });

  it('It should transfer 1000 tokens for 0.5 eth', async () => {
    let totalCoins = web3.toWei(500000, 'ether');
    let token = await Token.new(totalCoins, 'TEST', 18, 'TXT', {from : accounts[0]})
    let crowdsale = await Crowdsale.new(token.address, Date.now() / 1000 , endTime, softCap, hardCap, accounts[0], wallet, { from : accounts[0] });
    await token.approve(crowdsale.address, totalCoins, { from: accounts[0] });
    let contribution = await crowdsale.contribute({ value: web3.toWei(0.5, "ether"),  from : accounts[1] });
    let tokenBalance = await token.balanceOf(accounts[1]);
    assert (tokenBalance.toString() === '1000')
  });

});
