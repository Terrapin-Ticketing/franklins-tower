pragma solidity ^0.4.4;

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

import "./usingOraclize.sol";

contract Ticket is usingOraclize {
	address public master;
	address public owner;
	address public issuer;
	address public eventAddress;
	bool public isRedeemed = false;
	uint public usdPrice;

	bytes32 public oraclizeID;

	struct Tx { address sender; uint value; }
	mapping(bytes32 => Tx) public txIDs;

	/*Event*/
	event Log(uint num);

	function Ticket(address _master, address _issuer, address _owner, uint _usdPrice, address _eventAddress) {
		OAR = OraclizeAddrResolverI(0xc2556d55997FeEA408618296d18b7438DEF238A7);

		master = _master;
		issuer = _issuer;
		owner = _owner;
		usdPrice = _usdPrice; // in Wei
		eventAddress = _eventAddress;
	}

	function __callback(bytes32 _oraclizeID, string _result) {
		require(msg.sender == oraclize_cbAddress());
		uint etherPriceUSDCents = parseInt(_result, 2);

		uint pricePerCent = 1 ether / etherPriceUSDCents;
		uint amountRequired = pricePerCent * usdPrice;

		Tx tx = txIDs[_oraclizeID];

		if (tx.value < amountRequired) return tx.sender.transfer(tx.value); // refund user

		uint excessFunds = tx.value - amountRequired; // calculate any excess funds
		tx.sender.transfer(excessFunds); // return any extra funds
		issuer.transfer(amountRequired); // send ether to event creater
		owner = tx.sender;
		Log(this.balance);
	}

	function buyTicket() payable {
		require(owner == issuer); // make sure ticket is not owned by someone else
		require(isRedeemed == false); // make sure ticket hasn't already been redeemed

		oraclizeID = oraclize_query("URL","json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
		txIDs[oraclizeID] = Tx(msg.sender, msg.value);

		// need the ability to refund if oracalize doesn't work
	}

	function setOwner(address _newOwner) { // 0.9
		require(msg.sender == master);
		owner = _newOwner;
	}

	function transferTicket(address _recipient) {
		require(owner == msg.sender);
		require(isRedeemed == false);
		owner = _recipient;
	}

	function redeemTicket() {
		require(msg.sender == issuer);
		require(isRedeemed == false);
		isRedeemed = true;
	}

	function getBalance() constant returns (uint) {
		return this.balance;
	}
}
