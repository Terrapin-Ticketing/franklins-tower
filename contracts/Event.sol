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
	bytes32 public usdPrice;
	bytes32 public imageUrl;
	bytes32 public date; // unix timestamp

	// Venue Info
	bytes32 public venueName;
	bytes32 public venueAddress;
	bytes32 public venueCity;
	bytes32 public venueState;
	bytes32 public venueZip;


	function Event(
		address _master, address _owner, bytes32 _name, bytes32 _usdPrice,
		bytes32 _imageUrl, bytes32 _date, bytes32 _venueName, bytes32 _venueAddress,
		bytes32 _venueCity, bytes32 _venueState, bytes32 _venueZip
	) {
		master = _master;
		owner = _owner;
		name = _name;
		usdPrice = _usdPrice;
		imageUrl = _imageUrl;
		date = _date;
		venueName = _venueName;
		venueAddress = _venueAddress;
		venueCity = _venueCity;
		venueState = _venueState;
		venueZip = _venueZip;
	}

	function printTicket(uint _usdPrice) {
		tickets.push(new Ticket(
			master,
			owner,
			owner,
			_usdPrice,
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
