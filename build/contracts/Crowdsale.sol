import "./StandardToken.sol";

pragma solidity ^0.4.8;

contract Crowdsale {

	StandardToken ERC20;
	address benefitiary;
	uint experimentCoins;

	//constructor
	function Crowdsale(address ERC20Address, address _benefitiary ){

		token = StandardToken(ERC20Address);
		benefitiary = _benefitiary;
	}

	function calculatePrice(uint weiSent ) constant returns (uint){

		// 1 ETH = 200 experimentCoins, * 100 = for decimal points  
		experimentCoins = ( weiSent * 200 * 100 ) / (10 ** 18) ; 

	}

	//send amount of experiment coins to a contributor who donated ETH
	function contribute() payable {

		uint numTokens = 1; //any ETH contibution will send 1 experiment-coin token
		token.transferFrom(benefitiary, msg.sender, numTokens);
	}




} //contract ends

/*Hypothetical Calculations

	Raise - 5000 ETH = 15 millions
	1 ETH = 200 EXP coins 

 */

//78999