import { ethers } from "hardhat";
import fs from "fs";

async function main() {
  const [owner] = await ethers.getSigners();
  const curiousPandas = await ethers.getContractFactory("CuriousPandasNFT");

  const NFTContract = await curiousPandas.deploy("curiousPandas", "CPD");
  // const NFTContract = await curiousPandas.deploy("testpd", "tpd");
  const deployAddress = await NFTContract.getAddress();
  console.log("curiousPandas NFT contract : ", deployAddress);

  const filename = "../curiouspandas_mint_app/src/contracts/contractAddress";
  fs.writeFile(filename, deployAddress, (err) => {
    if (err) {
      console.error("파일 생성 및 쓰기에 실패했습니다.");
      console.error(err);
      return;
    }
    console.log(`파일 "${filename}"에 텍스트를 성공적으로 썼습니다.`);
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
