pragma solidity ^0.4.4;

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Ticket {
	address public owner;
	address public publisher;
	address public eventAddress;
	uint public price;

	function Ticket(address _publisher, address _owner, address _eventAddress, uint _price) {
		publisher = _publisher;
		owner = _owner;
		eventAddress = _eventAddress;
		price = _price;
	}

	function buyTicket() payable { // NOTE: test exact price
		if (owner != publisher) throw;
		if (msg.value < price) throw;
		// should never be negative because of previous check
		uint extra = msg.value - price;
		// return any extra funds back to sender
		if (!msg.sender.send(extra)) throw;
		if (!publisher.send(msg.value)) throw;
		// set new owner
		owner = msg.sender;
	}
}
