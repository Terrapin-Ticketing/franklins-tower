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
	bytes32 public usdPrice;
	bytes32 public imageUrl;
	uint256 public date; // unix timestamp
	bytes32 public ageRestriction;

	// Venue Info
	bytes32 public venueName;
	bytes32 public venueAddress;
	bytes32 public venueCity;
	bytes32 public venueState;
	bytes32 public venueZip;


	function Event(address _owner, bytes32 _name, bytes32 _usdPrice, bytes32 _imageUrl, uint256 _date, bytes32 _ageRestriction,
		bytes32 _venueName, bytes32 _venueAddress, bytes32 _venueCity, bytes32 _venueState, bytes32 _venueZip) {
		owner = _owner;
		name = _name;
		usdPrice = _usdPrice;
		imageUrl = _imageUrl;
		date = _date;
		ageRestriction = _ageRestriction;
		venueName = _venueName;
		venueAddress = _venueAddress;
		venueCity = _venueCity;
		venueState = _venueState;
		venueZip = _venueZip;
	}

	function printTicket(uint _usdPrice) {
		require(msg.sender != owner);
		tickets.push(new Ticket(
			owner,
			owner,
			address(this),
			_usdPrice // in Wei
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
