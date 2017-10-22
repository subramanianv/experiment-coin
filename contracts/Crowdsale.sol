pragma solidity ^0.4.8;
import "./StandardToken.sol";

contract Crowdsale {

  StandardToken public token;
  uint public startTime;
  uint public endTime;
  uint public hardCap;
  uint public softCap;
  address public multiSig;
  address public beneficiary;
  uint public weiRaisedSoFar;



  function Crowdsale (address _tokenAddress,
    uint _startTime,
    uint _endTime,
    uint _softCap,
    uint _hardCap,
    address _beneficiary,
    address _multiSig) {

    token = StandardToken(_tokenAddress);
    assert(_startTime > 0 && _startTime >=now);
    assert(_endTime > _startTime);
    assert(_hardCap > _softCap);
    startTime = _startTime;
    endTime = _endTime;
    hardCap = _hardCap;
    multiSig = _multiSig;
    beneficiary = _beneficiary;
  }

  function contribute() public {

  }

  function refund() public {

  }

  function() payable {
    contribute();
  }
}
