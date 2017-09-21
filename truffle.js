const Web3 = require('web3');

const HDWalletProvider = require('truffle-hdwallet-provider');

let infura_apikey = 'ErkMqD1W4xWqfkfqNBnt';
let mnemonic = 'accuse extend real hat they eagle worry brisk earn drop deputy guide';

module.exports = {
  networks: {
    // development: {
    //   host: 'localhost',
    //   port: 8545,
    //   network_id: '*' // Match any network id
    // },
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*' // Match any network id
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, 'https://ropsten.infura.io/'+infura_apikey),
      // provider: 'https://ropsten.infura.io/',
      network_id: 3
    }
  }
};
// module.exports = {
//   networks: {
//     development: {
//       host: 'localhost',
//       port: 8545,
//       network_id: '*' // Match any network id
//     }
//   }
// };
