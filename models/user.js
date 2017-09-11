var mongoose = require('mongoose');

let UserSchema = mongoose.Schema({
  username: String,
  password: String,
  walletAddress: String,
  privateKey: String
});

let UserModel = mongoose.model('User', UserSchema);

module.exports = UserModel;
