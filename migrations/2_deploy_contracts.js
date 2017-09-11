let ConvertLib = artifacts.require("./ConvertLib.sol");
let EventManager = artifacts.require("./EventManager.sol");

module.exports = function(deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(EventManager)
    .then(() => {
      // run server with EventManager's new address
      require('../server')(EventManager.address);
    });
};
