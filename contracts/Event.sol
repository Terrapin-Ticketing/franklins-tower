pragma solidity ^0.4.4;

import "./Ticket.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Event {
	address public master;

	address public owner;
	address[] public tickets; // optimization
	uint public totalTickets = 0;

	bytes32 public name;

	function Event(address _master, address _owner, bytes32 _name) {
		master = _master;
		owner = _owner;
		name = _name;
	}

	function printTicket(uint _price) {
		if (msg.sender != owner) throw;
		tickets.push(new Ticket(
			master,
			owner,
			owner,
			_price, // in Wei
			address(this)
		));
		totalTickets++;
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
