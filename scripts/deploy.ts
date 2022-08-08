// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  const LockedMakeSomeChange = await ethers.getContractFactory("LockedMakeSomeChange");
  const lockedMakeSomeChange = await LockedMakeSomeChange.deploy();

  await lockedMakeSomeChange.deployed();
  console.log("MakeSomeChangeToken deployed to:", lockedMakeSomeChange.address);

  const MakeSomeChangeToken = await ethers.getContractFactory("MakeSomeChangeToken");
  const makeSomeChangeToken = await MakeSomeChangeToken.deploy(
    'MakeSomeChangeToken', 
    'MSC', 
    8, 
    10000000000, 
    '0x8F27D608c3D4deB4049468fa0Ea39Fcb081d498c', 
    lockedMakeSomeChange.address
  );

  await makeSomeChangeToken.deployed();
  console.log("MakeSomeChangeToken deployed to:", makeSomeChangeToken.address);

  const MakeSomeChangeDAO = await ethers.getContractFactory("MakeSomeChangeDAO");
  const makeSomeChangeDAO = await MakeSomeChangeDAO.deploy();

  await makeSomeChangeDAO.deployed();
  console.log("MakeSomeChangeDAO deployed to:", makeSomeChangeDAO.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
