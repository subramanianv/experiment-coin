import "./StandardToken.sol";

pragma solidity ^0.4.8;

contract Crowdsale {

	StandardToken ERC20;
	address benefitiary;
	uint experimentCoins;
	uint from;
	uint to;
	uint weiRaised;

	modifier isCrowdsaleOpen(current) { 
		if(current > to || current < from) {
			throw;
		}
		_ ;
	}
	

	//constructor
	function Crowdsale(address ERC20Address, address _benefitiary, uint _from, uint _to) {

		token = StandardToken(ERC20Address);
		benefitiary = _benefitiary;
		from = _from;
		to = _to;
	}

	function calculatePrice(uint weiSent ) constant returns (uint){

		// 1 ETH = 200 experimentCoins, * 100 = for decimal points  
		experimentCoins = ( weiSent * 200 * 100 ) / (10 ** 18) ; 

	}

	//send amount of experiment coins to a contributor who donated ETH
	function contribute() isCrowdsaleOpen(now) payable {

		uint numTokens = 1; //any ETH contibution will send 1 experiment-coin token
		token.transferFrom(benefitiary, msg.sender, numTokens);
		weiRaised += msg.value;
	}





} //contract ends

/*Hypothetical Calculations

	Raise - 5000 ETH = 15 millions
	1 ETH = 200 EXP coins 

 */

//78999