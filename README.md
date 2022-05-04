# MultiSig-Wallet
Functional MultiSig Wallet 
Coded in Solidity

A wallet created to improve regular security by requiring multiple signatures to finalize a transaction. 
Able to initialize other ETH addresses to be set as authorizors.

Can run through Remix IDE or set up Truffle to run on local machine.

To Start Up on Local Machine:
Must have Truffle installed and Solidity IDE to fire up instance

1) Open a terminal window and run truffle compile to compile contracts
2) Run truffle develop to fire up node with accounts/private keys
3) Run migrate to deploy contracts
4) Create an instance of the wallet by let wallet = await MulitSig.deployed()
5) Play around with the contract!

Currently setup to deploy only needing 1 signature between accounts[1] and accounts[2]
To change this simply move to multiSig_migrations 2 file and change the deployer method to your preference
