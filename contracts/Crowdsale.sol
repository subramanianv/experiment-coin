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
  address public multiSig;
  address public beneficiary;
  uint public weiRaised;
  mapping(address => uint256) public deposited;



  function Crowdsale (address _tokenAddress,
    uint _startTime,
    uint _endTime,
    uint256 _softCap,
    uint256 _hardCap,
    address _beneficiary,
    address _multiSig) {

    assert(_startTime > 0 && _startTime >=now);
    assert(_endTime > _startTime);
    assert(_hardCap > _softCap);
    assert(_beneficiary != address(0));
    assert(_multiSig != address(0));

    token = StandardToken(_tokenAddress);
    startTime = _startTime;
    endTime = _endTime;
    hardCap = _hardCap;
    multiSig = _multiSig;
    beneficiary = _beneficiary;

  }


  function contribute() public payable {
    assert(msg.value > 0);
    uint256 value = msg.value;
    uint256 tokenFor1ETH = 2000;
    uint256 rate = tokenFor1ETH.div(10**18);
    uint256 numTokens = rate.mul(value);
    weiRaised = weiRaised.add(msg.value);
    deposited[msg.sender] += msg.value;
    require(token.transferFrom(beneficiary, msg.sender, numTokens));

  }

  function refund(address investor) public {
    assert (deposited[investor] > 0);
    uint256 depositedValue = deposited[investor];
    deposited[investor] = 0;
    investor.transfer(depositedValue);
  }

  function() payable {
    contribute();
  }

  function finalizeCrowdsale() onlyOwner {
    multiSig.transfer(this.balance);
  }
}
