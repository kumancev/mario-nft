import { ethers, run } from "hardhat";

async function main() {
  const MarioNFT = await ethers.getContractFactory("MarioNFT");
  const marioNFT = await MarioNFT.deploy();

  await marioNFT.deployed();

  await run('verify:verify', {
    address: marioNFT.address,
    contract: 'contracts/MarioNFT.sol:MarioNFT'
  })

  console.log(
    `MarioNFT deployed to ${marioNFT.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
