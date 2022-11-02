// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const {ethers} = require("hardhat");
require("dotenv").config({path:".env"});
const{FEE, VRF_COORDINATOR, LINK_TOKEN, KEY_HASH} = require("../constants");

async function main() {
  /**
   * A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
   * so randomWinnerGame here is a contract factory for the instance of our RandomWinnerGame contract
   */

  const randomWinnerGame = await hre.ethers.getContractFactory("RandomWinnerGame");

  //deploy the contract
  const deployed_rwg_contract = await randomWinnerGame.deploy(VRF_COORDINATOR, LINK_TOKEN, FEE, KEY_HASH);
  

  await deployed_rwg_contract.deployed();

  console.log(
    `Random Winner Game deployed to ${deployed_rwg_contract.address}`
  );
  console.log("Verifying: ", deployed_rwg_contract.address);

  await sleep(100000);

  //verify the contract after deployment
  await hre.run("verify:verify",{
    address: deployed_rwg_contract.address,
    constructorArguments: [VRF_COORDINATOR, LINK_TOKEN, FEE, KEY_HASH],
  });
}

function sleep(ms){
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//Random Winner Game deployed to 0x8a13c03Ab37a04D05f1C24c64a3aE617BFd8E706
// Successfully verified contract RandomWinnerGame on Polygonscan.
// https://mumbai.polygonscan.com/address/0x8a13c03Ab37a04D05f1C24c64a3aE617BFd8E706#code
