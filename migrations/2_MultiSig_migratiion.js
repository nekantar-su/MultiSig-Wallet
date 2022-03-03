const multiSig = artifacts.require("MulitSig");

module.exports = function (deployer,netowrk,accounts) {
  deployer.deploy(multiSig,1,[accounts[1],accounts[2]]);
};
