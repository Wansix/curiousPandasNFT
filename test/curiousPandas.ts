import { expect } from "chai";
import hre from "hardhat";
import { ethers } from "hardhat";

describe("CuriousPandasNFT", async function () {
  let owner;
  let otherAccount;

  before(async function () {
    [owner, otherAccount] = await ethers.getSigners();
  });

  it("mintAndTransferTokens", async function () {
    [owner, otherAccount] = await ethers.getSigners();

    const CPD = await ethers.getContractFactory("CuriousPandasNFT");

    const contract = await CPD.deploy("curiousPandas", "CPD");

    await contract.advancePhase();
    await contract.advancePhase();
    await contract.advancePhase();
    await contract.advancePhase();
    await contract.advancePhase();

    const currentPhase = (await contract.currentPhase()).toString();
    console.log("currentPhase : ", currentPhase);

    await contract.setMintBlockTime(2, 0, 6000);

    for (let i = 0; i < 10; i++) {
      await contract.batchMintNFT(50);
    }

    const supply = (await contract.totalSupply()).toString();
    console.log("supply : ", supply);

    let h1 = 0;
    let h2 = 0;
    let h3 = 0;
    let h4 = 0;

    for (let i = 0; i < 500; i++) {
      const _hometown = Number(await contract.homeTown(i));
      // console.log("homeTown : ", _hometown);
      if (_hometown === 0) h1++;
      if (_hometown === 1) h2++;
      if (_hometown === 2) h3++;
      if (_hometown === 3) h4++;
    }

    console.log("h1 : ", h1);
    console.log("h2 : ", h2);
    console.log("h3 : ", h3);
    console.log("h4 : ", h4);

    const hh = await contract.getHomeTown(10);
    console.log("hh : ", hh);

    // const result = await contract.getPandaTokens(owner.address);
    // console.log("result : ", result[0]);

    // //transfer MAT Token
    // await MATContract.transfer(
    //   otherAccount.address,
    //   transferAmountToOtherAccount
    // );
    // const otherAccountMatBalance = await MATContract.balanceOf(
    //   otherAccount.address
    // );

    // expect(otherAccountMatBalance).to.equal(transferAmountToOtherAccount);

    // //mint MBT Token
    // const MBT = await ethers.getContractFactory("MBT");

    // MBTContract = await MBT.deploy(mintAmountMBT);
    // const MBTsupply = (await MBTContract.totalSupply()).toString();

    // console.log("");
    // console.log("Test token Mint");
    // console.log("MAT mint : ", MATsupply);
    // console.log("MBT mint : ", MBTsupply);

    // const ownerTokenA_amount = (
    //   await MATContract.balanceOf(owner.address)
    // ).toString();
    // const ownerTokenB_amount = (
    //   await MBTContract.balanceOf(owner.address)
    // ).toString();
    // const otherTokenA_amount = (
    //   await MATContract.balanceOf(otherAccount.address)
    // ).toString();
    // const otherTokenB_amount = (
    //   await MBTContract.balanceOf(otherAccount.address)
    // ).toString();

    // console.log("");
    // console.log("token amount");
    // console.log("");
    // console.log("owner : ", owner.address);
    // console.log(
    //   `tokenA : ${ownerTokenA_amount}, tokenB : ${ownerTokenB_amount}`
    // );
    // console.log("");
    // console.log("other : ", otherAccount.address);
    // console.log(
    //   `tokenA : ${otherTokenA_amount}, tokenB : ${otherTokenB_amount}`
    // );

    // expect(ownerTokenA_amount).to.equal(
    //   (mintAmountMAT - transferAmountToOtherAccount).toString()
    // );
    // expect(ownerTokenB_amount).to.equal(mintAmountMBT.toString());
    // expect(otherTokenA_amount).to.equal(
    //   transferAmountToOtherAccount.toString()
    // );
    // expect(otherTokenB_amount).to.equal("0");
  });
});
