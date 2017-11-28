const request = require('request-promise');
const config = require('config');
const EthereumBip44 = require('ethereum-bip44');

let eyesUri = config.get('uri');

let walletAddress;
if (config.privateSeed) {
  let wallet = EthereumBip44.fromPrivateSeed(config.privateSeed);
  walletAddress = wallet.getAddress(0);
} else {
  // default test address
  walletAddress = '0xd1032b572ef650f0960f46c3b063c9ea71aff1df';
}

let abis = JSON.stringify({
  terrapin: require('./build/contracts/EventManager'),
  event: require('./build/contracts/Event'),
  ticket: require('./build/contracts/Ticket')
});

let { terrapinAddress } = require('./build/info.json');

let options = {
  method: 'POST',
  uri: eyesUri,
  body: {
    abis,
    terrapinAddress,
    walletAddress
  },
  json: true // Automatically stringifies the body to JSON
};

// securly send abis to "eyes"
request(options)
  .then((res) => {
    if (res.success !== true) throw new Error('Upload Failed');
    console.log('Upload Complete');
  })
  .catch((err) => {
    console.log('\nError: ', err.message, '\n');
  });
