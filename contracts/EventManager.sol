pragma solidity ^0.4.4;

import "./Event.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract EventManager {
	address public master;
	address[] public events;

	event EventCreated(address _eventAddress);

	/*mapping (address => address[]) guestList;
	address[] tickets = guestList[walletAddress]*/

	function EventManager() {
		master = msg.sender;
	}

	function createEvent(bytes32 _eventName) {
		Event ev = new Event(
			master,
			msg.sender,
			_eventName
		);
		// dispatch an event
		events.push(ev);
		EventCreated(address(ev));
	}

	function getEvents() constant returns(address[]) {
		return events;
	}

}
