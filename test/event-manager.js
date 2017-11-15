let Web3 = require('web3');
let web3 = new Web3(new Web3.providers.HttpProvider('http://192.168.12.226:8545'));
let pasync = require('pasync');

let EventManager = artifacts.require('./EventManager.sol');
let Event = artifacts.require('./Event.sol');
let Ticket = artifacts.require('./Ticket.sol');

let requestPromise = require('request-promise');

web3.utils.toAsciiOriginal = web3.utils.toAscii;
web3.utils.toAscii = function(input) { return web3.utils.toAsciiOriginal(input).replace(/\u0000/g, ''); };

function deployed() {
  return EventManager.deployed();
}

function guidGenerator() {
  var S4 = function() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
  };
  return (S4()+S4()+'-'+S4()+'-'+S4()+'-'+S4()+'-'+S4()+S4()+S4());
}

let wei = 1000000000000000000;
let TICKET_QTY = 10;

contract('EventManager', function(accounts) {
  before(function() {
    let eventName = 'String Cheese Incident @ Colorado';
    let price = 1;

    let terrapin;
    return deployed().then((_terrapin) => {
      terrapin = _terrapin; // make global for use in later "then"s
      this.terrapinInstance = terrapin;

      return terrapin.createEvent(
        eventName, 1000, 'date',
        {
          from: accounts[1],
          gas: 4700000
        });
    })
      .then(() => terrapin.getEvents.call())
      .then((eventAddresses) => {
        let eventInstance = Event.at(eventAddresses[0]);
        return pasync.eachSeries(new Array(TICKET_QTY), () => {
          return eventInstance.printTicket(price, {
            from: accounts[1],
            gas: 4700000
          });
        }).then(() => eventInstance);
      })
      .then((eventInstance) => {
        this.eventInstance = eventInstance;
      });
  });

  before(function() {
    this.nextTicket = 0;
    let ticketInstances = [];
    return this.eventInstance.getTickets.call()
      .then((ticketAddresses) => {
        return pasync.eachSeries(ticketAddresses, (ticketAddress) => {
          ticketInstances.push(Ticket.at(ticketAddress));
        });
      })
      .then(() => {
        this.getTicketInstance = () => {
          return new Promise((resolve) => {
            resolve(ticketInstances[this.nextTicket++]);
          });
        };
      });
  });

  before(function() {
    return requestPromise('https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD')
      .then((res) => {
        this.etherPrice = JSON.parse(res).USD;
      });
  });

  it('should buy a ticket', function() {
    let ticketInstance, owner;

    return this.getTicketInstance()
      .then((_ticketInstance) => {
        ticketInstance = _ticketInstance;
        return ticketInstance.buyTicket({
          from: accounts[2],
          gas: 4700000,
          value: wei * 20
        });
      })
      .then(() => {
        return ticketInstance.owner.call().then((_owner) => {
          owner = _owner;
        });
      })
      .then(() => {
        let boughtEvent = ticketInstance.Bought();
        return new Promise((resolve, reject) => {
          boughtEvent.watch((err, result) => {
            if (err) return reject(err);
            assert(Boolean(result.args.status) === true);
            resolve();
            boughtEvent.stopWatching();
          });
        });
      })
      .then(() => {
        return ticketInstance.owner.call().then((newOwner) => {
          assert(owner !== newOwner);
        });
      });
  });

  it('should call masterBuy from master account', function() {
    let ticketInstance;

    return this.getTicketInstance()
      .then((_ticketInstance) => ticketInstance = _ticketInstance)
      .then(() => {
        return ticketInstance.masterBuy(accounts[1], {
          from: accounts[0],
          gas: 4700000
        });
      })
      .then(() => ticketInstance.isForSale.call())
      .then((_isForSale) => {
        return ticketInstance.owner.call().then((_owner) => {
          assert(_owner === accounts[1]);
          assert(_isForSale === false);
        });
      });
  });

  it('should set is for sale', function() {
    let ticketInstance, owner;

    return this.getTicketInstance()
      .then((_ticketInstance) => {
        ticketInstance = _ticketInstance;
        return ticketInstance.buyTicket({
          from: accounts[2],
          gas: 4700000,
          value: wei * 20
        });
      })
      .then(() => {
        return ticketInstance.owner.call().then((_owner) => {
          owner = _owner;
        });
      })
      .then(() => {
        let boughtEvent = ticketInstance.Bought();
        return new Promise((resolve, reject) => {
          boughtEvent.watch((err, result) => {
            if (err) return reject(err);
            assert(Boolean(result.args.status) === true);
            resolve();
            boughtEvent.stopWatching();
          });
        });
      })
      .then(() => {
        return ticketInstance.owner.call().then((newOwner) => {
          assert(owner !== newOwner);
        });
      })
      .then(() => {
        return ticketInstance.setIsForSale(true, {
          from: accounts[2],
          gas: 4700000
        });
      })
      .then(() => ticketInstance.isForSale.call())
      .then((isForSale) => {
        assert(isForSale);
      });
  });

});
