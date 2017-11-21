pragma solidity ^0.4.10;

import "./EventManager.sol";
import "./Ticket.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Event {
	address public terrapin;
	address public master;
	address public owner;

	// userAddress -> owned tickets[]
	mapping (address => address[]) private ticketOwnerTickets;
	address[] private ticketOwnerIndex;

	address[] private tickets; // optimization

	uint public soldTickets = 0;
	int public maxTickets; // -1 means an unlimited supply

	bytes32 public name;
	uint public startDate; // unix timestamp
	uint public endDate; // unix timestamp

	// Venue Info
	bytes32 public venueName;
	bytes32 public venueAddress;
	bytes32 public venueCity;
	bytes32 public venueState;
	bytes32 public venueZip;

	function Event(address _terrapin, address _master, address _owner, bytes32 _name,
		int _maxTickets, uint _startDate, uint _endDate
	) {
		terrapin = _terrapin;
		maxTickets = _maxTickets; // -1 means an unlimited supply
		master = _master;
		owner = _owner;
		name = _name;
		startDate = _startDate;
		endDate = _endDate;
	}

	function printTicket(address _ticketOwner, uint _usdPrice) {
		require(int(soldTickets) <= maxTickets || maxTickets == -1);
		Ticket ticket = new Ticket(
			terrapin,
			master,
			owner,
			_ticketOwner,
			_usdPrice,
			address(this)
		);
		tickets.push(ticket);
		soldTickets++;
	}

	function getTickets() constant returns(address[]) {
		return tickets;
	}
}
