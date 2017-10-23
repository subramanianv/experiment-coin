pragma solidity ^0.4.8;
import "./StandardToken.sol";
import "./SafeMath.sol";
import "./Ownable.sol";

contract Crowdsale is Ownable {
  using SafeMath for uint256;
  StandardToken public token;
  uint public startTime;
  uint public endTime;
  uint256 public hardCap;
  uint256 public softCap;
  address public wallet;
  address public beneficiary;
  uint public weiRaised;
  mapping(address => uint256) public deposited;



  function Crowdsale (address _tokenAddress,
    uint _startTime,
    uint _endTime,
    uint256 _softCap,
    uint256 _hardCap,
    address _beneficiary,
    address _wallet) {

    require(_startTime > 0 && _startTime >=now);
    require(_endTime > _startTime);
    require(_hardCap > _softCap && _softCap > 0);
    require(_beneficiary != address(0));
    require(_wallet != address(0));

    token = StandardToken(_tokenAddress);
    startTime = _startTime;
    endTime = _endTime;
    hardCap = _hardCap;
    wallet = _wallet;
    beneficiary = _beneficiary;

  }


  function contribute()  public payable {
    require(validPurchase());
    uint256 value = msg.value;
    uint256 tokenForOneETH = 2000;
    uint256 rate = tokenForOneETH.div(10**18);
    uint256 numTokens = rate.mul(value);
    weiRaised = weiRaised.add(msg.value);
    deposited[msg.sender] += msg.value;
    require(token.transferFrom(beneficiary, msg.sender, numTokens));

  }

  function refund() public {
    require(hasEnded());
    require(!goalReached());
    address investor = msg.sender;
    require(deposited[investor] > 0);
    uint256 depositedValue = deposited[investor];
    deposited[investor] = 0;
    investor.transfer(depositedValue);
  }

  function validPurchase() returns(bool) {
    bool withinReached = weiRaised.add(msg.value) <= hardCap;
    return !hasEnded() && !withinReached;
  }

  function() payable {
    contribute();
  }

  function finalizeCrowdsale() onlyOwner {
    require(goalReached());
    require(!hasEnded());
    wallet.transfer(this.balance);
  }

  function hasEnded() public constant returns(bool) {
    return now > hasEnded;
  }

  function hardCapReached() public constant returns(bool) {
    return weiRaised >= hardCap;
  }
  function goalReached() public constant returns(bool) {
    return weiRaised >= softCap;
  }
}
