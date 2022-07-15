import { Provider } from "@ethersproject/abstract-provider";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Signer } from "ethers";
import { ethers } from "hardhat";
import { MakeSomeChangeToken } from "../typechain";

describe("MakeSomeChangeToken", function () {
  let MakeSomeChangeToken;
  let makeSomeChangeToken: MakeSomeChangeToken;
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;

  this.beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    const LockedMakeSomeChange = await ethers.getContractFactory("LockedMakeSomeChange");
    const lockedMakeSomeChange = await LockedMakeSomeChange.deploy();
  
    await lockedMakeSomeChange.deployed();
  
    MakeSomeChangeToken = await ethers.getContractFactory("MakeSomeChangeToken");
    makeSomeChangeToken = await MakeSomeChangeToken.deploy(
      'MakeSomeChangeToken', 
      'MSC', 
      8, 
      10000000000, 
      '0x8F27D608c3D4deB4049468fa0Ea39Fcb081d498c', 
      lockedMakeSomeChange.address
    );
  
    await makeSomeChangeToken.deployed();
  })

  it("Should lock a quarter of the token when transferring", async function () {
      // Transfer 50 tokens from owner to addr1
      await makeSomeChangeToken.transferFrom(owner.address, addr1.address, 50);
      const addr1Balance = await makeSomeChangeToken.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(50);

      // Transfer 50 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await makeSomeChangeToken.connect(addr1).transferFrom(addr1.address,addr2.address, 50);
      const addr2Balance = await makeSomeChangeToken.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
  });
});
