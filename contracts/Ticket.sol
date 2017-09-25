pragma solidity ^0.4.4;

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Ticket {
	address public owner;
	address public issuer;
	address public eventAddress;
	bool public isRedeemed = false;
	uint public price;

	function Ticket(address _issuer, address _owner, address _eventAddress, uint _price) {
		issuer = _issuer;
		owner = _owner;
		eventAddress = _eventAddress;
		price = _price; // in Wei
	}

	function buyTicket() payable {
		require(owner == issuer);
		require(isRedeemed == false);
		require(msg.value >= price); // in Wei
		// should never be negative because of previous check
		uint extra = msg.value - price;
		// return any extra funds back to sender
		if (!msg.sender.send(extra)) revert();
		if (!issuer.send(msg.value)) revert();
		// set new owner
		owner = msg.sender;
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

}
