# VRF Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a contract, a test for that contract, and a script that deploys that contract.

## vrf-chainlink

When dealing with computers, randomness is an important but difficult issue to handle due to a computer's deterministic nature. This is true even more so when speaking of blockchain because not only is the computer deterministic, but it is also transparent. As a result, trusted random numbers cannot be generated natively in Solidity because randomness will be calculated on-chain which is public info to all the miners and the users.

So we can use some web2 technologies to generate the randomness and then use them on-chain.


## What is an oracle?
An oracle sends data from the outside world to a blockchain's smart contract and vice-verca.
Smart contract can then use this data to make a decision and change its state.
They act as bridges between blockchains and the external world.
However it is important to note that the blockchain oracle is not itself the data source but its job is to query, verify and authenticate the outside data and then futher pass it to the smart contract.
Today we will learn about one of oracles named Chainlink VRF's

Lets goo 🚀


>Chainlink VRF (Verifiable Random Function) is a provably-fair and verifiable source of randomness designed for smart contracts. Smart contract developers can use Chainlink VRF as a tamper-proof random number generator (RNG) to build reliable smart contracts for any applications which rely on unpredictable outcomes.


Try running some of the following tasks:

```shell
yarn hardhat help
yarn hardhat test
REPORT_GAS=true npx hardhat test
yarn hardhat node
yarn hardhat run scripts/deploy.js
```
