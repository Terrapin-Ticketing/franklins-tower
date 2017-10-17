pragma solidity ^0.4.4;

import "./Event.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract EventManager {
	address public owner;
	address[] public events;

	event EventCreated(address _eventAddress);

	/*mapping (address => address[]) guestList;

	address[] tickets = guestList[walletAddress]*/

	function EventManager() {
		owner = msg.sender;
	}

	function createEvent(bytes32 _eventName, bytes32 _usdPrice,bytes32 _imageUrl, uint256 _date, bytes32 _ageRestriction,
		bytes32 _venueName, bytes32 _venueAddress, bytes32 _venueCity, bytes32 _venueState, bytes32 _venueZip) {
		Event ev = new Event(
			msg.sender,
			_eventName,
			_usdPrice,
			_imageUrl,
			_date,
			_ageRestriction,
			_venueName,
			_venueAddress,
			_venueCity,
			_venueState,
			_venueZip
		);
		// dispatch an event
		events.push(ev);
		EventCreated(address(ev));
	}

	function getEvents() constant returns(address[]) {
		return events;
	}

}
