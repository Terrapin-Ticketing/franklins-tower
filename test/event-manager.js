let Web3 = require('web3');
let web3 = new Web3(new Web3.providers.HttpProvider('http://192.168.12.226:8545'));
let pasync = require('pasync');

let EventManager = artifacts.require('./EventManager.sol');
let Event = artifacts.require('./Event.sol');
let Ticket = artifacts.require('./Ticket.sol');

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


contract('EventManager', function(accounts) {
  it.only('should connect to oracleize', () => {
    let eventName = 'String Cheese Incident @ Colorado';
    let price = 1;

    let terrapin;
    return deployed().then((_terrapin) => {
      terrapin = _terrapin; // make global for use in later "then"s
      // console.log(JSON.stringify(terrapin.abi, null, '  '), terrapin.address);

      // bytes32 _eventName, bytes32 _usdPrice,
      // bytes32 _imageUrl, bytes32 _date, bytes32 _venueName,
      // bytes32 _venueAddress, bytes32 _venueCity, bytes32 _venueState,
      // bytes32 _venueZip

      return terrapin.createEvent(
        eventName, 1000, 'someurl', 'date', 'venueName', 'vanueAddress 123',
        'city', 'state', 'zip',
        {
          from: accounts[1],
          gas: 4700000
        });
    })
      .then((tx) => terrapin.getEvents.call())
      .then((eventAddresses) => {
        let eventInstance = Event.at(eventAddresses[0]);
        return eventInstance.printTicket(price, {
          from: accounts[1],
          gas: 4700000
        }).then(() => eventInstance);
      })
      .then((eventInstance) => {
        return eventInstance.getTickets.call()
          .then((ticketAddrs) => Ticket.at(ticketAddrs[0]))
          .then((ticketInstance) => {
            return ticketInstance.owner.call()
              .then((owner) => {
                console.log('original owner: ', owner);
              })
              .then(() => ticketInstance);
          });
      })
      .then((ticketInstance) => {
        return Promise.resolve()
          .then(() => ticketInstance.usdPrice.call())
          .then((price) => {
            // TODO: make this get balance from https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD
            let ether = 30980; // cost in cents
            let weiPrice = Math.ceil(price / ether * wei);
            console.log('weiPrice', weiPrice);
            return weiPrice;
          })
          .then((weiPrice) => {
            return ticketInstance.buyTicket({
              from: accounts[2],
              gas: 4700000,
              value: weiPrice * 2
            });
          })
          .then(() => {
            return new Promise((resolve) => {
              console.log('waiting');
              setTimeout(() => {
                resolve();
              }, 55000);
            });
          })
          .then(() => ticketInstance.owner.call())
          .then((owner) => {
            console.log('new owner:', owner);
          })
          .then(() => ticketInstance.getBalance.call())
          .then((balance) => {
            console.log('ticket balance:', balance);
          });
      });
  });


  it('should init manager', function() {
    return deployed().then((terrapin) => terrapin.owner.call())
      .then((ownerAddress) => {
        assert(ownerAddress === accounts[0]);
        // assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
      });
  });

  it('should create 5 events', function() {
    let terrapin;
    return deployed().then((_terrapin) => {
      terrapin = _terrapin; // make global for use in later "then"s
      // console.log(JSON.stringify(terrapin.abi, null, '  '), terrapin.address);
      let numTimes = [ 1, 2, 3, 4, 5, 6 ];
      return pasync.eachSeries(numTimes, () => {
        return terrapin.createEvent(
          guidGenerator(),
          {
            from: accounts[1],
            gas: 4700000
          }
        )
          .then((tx) => web3.eth.getTransactionReceipt(tx.tx))
          .then((test) => {
            console.log('test:', test);
          });
      });
    });
  });

  it('should create an event and issue tickets', function() {
    let terrapin;

    function createEvent(name, price, i) {
      // console.log('i', i);
      var event = terrapin.EventCreated(null, () => {
        console.log('event triggred');
      });

      // // watch for changes
      // event.watch(function(error, result) {
      //   if (!error) {
      //     console.log(result);
      //   }
      //   console.log('result!', result);
      // });

      // // Or pass a callback to start watching immediately
      // var event = myContractInstance.MyEvent([{valueA: 23}] [, additionalFilterObject] , function(error, result){
      //   if (!error)
      //     console.log(result);
      // });

      return terrapin.createEvent(name,
        {
          from: accounts[1],
          gas: 4700000
        }
      )
        .then(() => terrapin.getEvents.call())
        .then((eventAddrs) => Event.at(eventAddrs[i]))
        .then((eventInstance) => {
          // shuuld be done with doWhielst
          // let numTickets = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
          let numTickets = [1, 2, 3, 4, 5, 6, 7];
          return pasync.eachSeries(numTickets, () => {
            return eventInstance.printTicket(price, {
              from: accounts[1],
              gas: 4700000
            }).then((tx) => {
              // console.log(tx);
            });
          });
        });
    }

    return deployed().then((_terrapin) => {
      terrapin = _terrapin; // make global for use in later "then"s
      console.log('address: ', terrapin.address);
    })
      .then(() => {
        let i = 0;
        return pasync.eachSeries([
          { name: 'The String Cheese Incident', price: 1 },
          { name: 'Phish @ MSG', price: 80 }
          // { name: 'DSO @ Taft', price: 40 },
          // { name: 'Marcus King Band @ Hamilton', price: 15 },
          // { name: 'Greensky Bluegrass in the woods', price: 75 }
        ], (obj) => {
          return createEvent(obj.name, (obj.price * 1000000000000000000), i)
            .then(() => {
              i++;
            });
        });
      });
  });

  it('should buy ticket', function() {
  });

  // it('should', function() {
  //   return x;
  // });
});
