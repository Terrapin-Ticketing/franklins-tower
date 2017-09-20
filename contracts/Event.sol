pragma solidity ^0.4.4;

import "./Ticket.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Event {
	address public owner;
	address[] public tickets;

	bytes32 public name;

	function Event(address _owner, bytes32 _name) {
		owner = _owner;
		name = _name;
	}

	function printTicket(uint _price) {
		if (msg.sender != owner) throw;
		tickets.push(new Ticket(
			owner,
			owner,
			address(this),
			_price
		));
	}

	function getTickets() constant returns(address[]) {
		return tickets;
	}

	/*function buyTicket(address _ticketAddress) payable {
		Ticket ticket = Ticket(_ticketAddress);

		if (ticket.owner() == owner) throw;
		if (msg.value < ticket.price()) throw;
		bool success = owner.send(msg.value);
		if (!success) throw;

	}*/

}
