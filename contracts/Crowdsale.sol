pragma solidity ^0.4.8;
import "./StandardToken.sol";
import "./SafeMath.sol";
import "./Ownable.sol";
import "./Pausable.sol";

contract Crowdsale is Ownable, Pausable {
  using SafeMath for uint256;
  StandardToken public token;
  uint256 public startTime;
  uint256 public endTime;
  uint256 public hardCap;
  uint256 public softCap;
  address public wallet;
  address public beneficiary;
  uint256 public weiRaised;
  uint256 public tokenSold = 0;
  uint256 public TOKEN_FOR_ONE_ETH = 2000;

  mapping(address => uint) public whitelist;

  mapping(address => uint256) public deposited;
  event TokensPurchased(address indexed _to, uint256 _tokens);

  modifier beforeCrowdsale() {
    require(now < startTime);
    _;
  }

  modifier afterCrowdsale() {
    require(this.balance >= hardCap || now > endTime);
    _;
  }

  modifier duringCrowdsale() {
    require(this.balance < hardCap && now >=startTime && now <=endTime);
    _;
  }

  function Crowdsale (address _tokenAddress,
    uint _startTime,
    uint duration,
    uint256 _softCap,
    uint256 _hardCap,
    address _beneficiary,
    address _wallet) {
    require(_startTime >= now);
    require(duration > 0);
    require(_hardCap > _softCap && _softCap > 0);
    require(_beneficiary != address(0));
    require(_wallet != address(0));

    token = StandardToken(_tokenAddress);
    startTime = _startTime;
    endTime = _startTime + (duration * 1 days);
    hardCap = _hardCap;
    wallet = _wallet;
    beneficiary = _beneficiary;
  }

  function calculateTokensForContribution(uint256 value) internal returns(uint256) {
    uint256 numTokens = value.mul(TOKEN_FOR_ONE_ETH);
    numTokens = numTokens.div(10**18);
    return numTokens;
  }

  function contribute()  whenNotPaused duringCrowdsale public payable returns (uint256) {
    uint256 value = msg.value;
    require(validPurchase(value));
    uint256 numTokens = calculateTokensForContribution(value);
    weiRaised = weiRaised.add(msg.value);
    uint256 currentContribution = deposited[msg.sender];
    deposited[msg.sender] = currentContribution.add(msg.value);
    tokenSold = tokenSold.add(numTokens);
    require(token.balanceOf(beneficiary) >= numTokens);
    require(token.transferFrom(beneficiary, msg.sender, numTokens));
    TokensPurchased(msg.sender, numTokens);
    return numTokens;
  }

  function refund(address investor) afterCrowdsale onlyOwner whenNotPaused public {
    require(!goalReached());
    require(deposited[investor] > 0);
    uint256 depositedValue = deposited[investor];
    deposited[investor] = 0;
    investor.transfer(depositedValue);
  }

  function addInvestorToWhitelist(address[] investors, uint[] tiers) beforeCrowdsale public {
    require(investors.length == tiers.length);
    for(uint i=0;i<investors.length;i++) {
      whitelist[investors[i]] = tiers[i];
    }
  }

  function validPurchase(uint256 value) internal returns(bool) {
    bool withinCap = weiRaised.add(value) <= hardCap;
    return withinCap;
  }

  function() payable {
    contribute();
  }

  function finalizeCrowdsale() whenNotPaused afterCrowdsale onlyOwner public {
    require(goalReached());
    wallet.transfer(this.balance);
  }

  function goalReached() public constant returns(bool) {
    return weiRaised >= softCap;
  }

  function getContributionAmount(address contributor) public constant returns(uint256) {
    return deposited[contributor];
  }
}
