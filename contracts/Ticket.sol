pragma solidity ^0.4.4;

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Ticket {
	address public master;
	address public owner;
	address public issuer;
	address public eventAddress;
	bool public isRedeemed = false;
	uint public usdPrice;

	function Ticket(address _master, address _issuer, address _owner, uint _usdPrice, address _eventAddress) {
		master = _master;
		issuer = _issuer;
		owner = _owner;
		usdPrice = _usdPrice; // in Wei
		eventAddress = _eventAddress;
	}

	// TODO: Make usable for USD...this is broken
	function buyTicket() payable {
		require(owner == issuer);
		require(isRedeemed == false);
		/*require(msg.value >= usdPrice); // in Wei
		// should never be negative because of previous check
		uint extra = msg.value - price;
		// return any extra funds back to sender
		if (!msg.sender.send(extra)) revert();
		if (!issuer.send(msg.value)) revert();*/
		// set new owner
		owner = msg.sender;
	}

	function setOwner(address _newOwner) { // 0.9
		require(msg.sender == master);
		owner = _newOwner;
	}

	function transferTicket(address _recipient) {
		require(owner == msg.sender);
		require(isRedeemed == false);
		owner = _recipient;
	}

	function redeemTicket() {
		require(msg.sender == issuer);
		require(isRedeemed == false);
		isRedeemed = true;
	}

}
