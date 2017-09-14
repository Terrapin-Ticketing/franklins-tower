const request = require('request-promise');
const config = require('config');

let eyesUri = config.get('uri');

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
    terrapinAddress
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
