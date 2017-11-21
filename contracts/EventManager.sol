pragma solidity ^0.4.10;

import "./Event.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract EventManager {
	address public master;
	address[] public events;
	mapping(address => address[]) public eventIssuerLookupTable;
	address test;

	event EventCreated(address _eventAddress);

	/*mapping (address => address[]) guestList;
	address[] tickets = guestList[walletAddress]*/

	function EventManager() {
		master = msg.sender;
	}

	function createEvent(bytes32 _eventName, int _maxTickets,
		uint _startDate, uint _endDate
	) {
		Event ev = new Event(address(this), master, msg.sender, _eventName,
			_maxTickets, _startDate, _endDate);
		// dispatch an event
		events.push(address(ev));
		eventIssuerLookupTable[msg.sender].push(address(ev));
		test = msg.sender;
		EventCreated(address(ev));
	}

	function getEvents() constant returns(address[]) {
		return events;
	}

	function getEventsByOwner(address _owner) constant returns(address[]) {
		return eventIssuerLookupTable[_owner];
	}
}
