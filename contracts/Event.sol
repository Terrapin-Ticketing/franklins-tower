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
	uint public baseUSDPrice;

	// Venue Info
	bytes32 public venueName;
	bytes32 public venueAddress;
	bytes32 public venueCity;
	bytes32 public venueState;
	bytes32 public venueZip;

	// ticketType => price
	mapping (bytes32 => uint) private ticketTypes;

	function Event(address _terrapin, address _master, address _owner, bytes32 _name,
		int _maxTickets, uint _usdPrice, uint _startDate, uint _endDate
	) {
		terrapin = _terrapin;
		maxTickets = _maxTickets; // -1 means an unlimited supply
		master = _master;
		owner = _owner;
		name = _name;
		startDate = _startDate;
		endDate = _endDate;
		baseUSDPrice = _usdPrice;

		// default ticket type
		ticketTypes["GA"] = _usdPrice;
	}

	function printTicket(address _ticketOwner, bytes32 _type) {
		require(msg.sender == owner || msg.sender == master);
		require(int(soldTickets) <= maxTickets || maxTickets == -1);
		Ticket ticket = new Ticket(
			terrapin,
			master,
			owner,
			_ticketOwner,
			ticketTypes[_type],
			_type,
			address(this)
		);
		tickets.push(address(ticket));
		soldTickets++;
	}

	function addTicketType(bytes32 _type, uint _usdPrice) {
		require(msg.sender == owner || msg.sender == master);
		ticketTypes[_type] = _usdPrice;
	}

	function getRemainingTickets() constant returns(int remainingTickets) {
		return maxTickets - int(tickets.length);
	}

	function getTickets() constant returns(address[]) {
		return tickets;
	}

	function getTicketPrice(bytes32 _type) constant returns(uint usdPrice){
		return ticketTypes[_type];
	}

	/*function userPrintTicket(bytes32 _type) {
		require(int(soldTickets) <= maxTickets || maxTickets == -1);
		Ticket ticket = new Ticket(
			terrapin,
			master,
			owner,
			_ticketOwner,
			baseUSDPrice,
			_type,
			address(this)
		);
		tickets.push(address(ticket));
		soldTickets++;
	}*/
}
