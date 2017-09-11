var UserModel = require('./models/user');
var Web3 = require('web3');

let web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

class UserApi {
  register(username, password) {
    let wallet = web3.eth.accounts.create();
    return UserModel.create({ username, password, walletAddress: wallet.address, privateKey: wallet.privateKey });
  }

  getUser(username, password) {
    return new Promise((resolve, reject) => {
      UserModel.find({username, password}).exec((err, res) => {
        if (err) return reject(err);
        if (res.length === 0) return reject(new Error('no account'));
        return resolve(res);
      });
    });
  }
}

module.exports = UserApi;
