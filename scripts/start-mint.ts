/* eslint-disable indent */
import { ATXDAOUkraineNFT } from '../typechain-types/ATXDAOUkraineNFT';
import { assertValidTokenUri } from '../util/assertions';
import { getContractAddress } from '../util/contract-meta';
import { dynamicGetGasPrice } from '../util/gas-now';
import { task } from 'hardhat/config';

interface StartMintArgs {
  contractAddress?: string;
  gasPrice?: string;
  tokenUri: string;
  mintPrice: string;
}

task<StartMintArgs>('start-mint', 'enable nft minting')
  .addOptionalParam('contractAddress', 'nftv2 contract address')
  .addOptionalParam(
    'gasPrice',
    'gas price in wei to deploy with (uses provider.getGasPrice() otherwise)'
  )
  .addParam('root', 'merkle root')
  .addParam('tokenUri', 'base token uri (should end with "/"')
  .setAction(
    async (
      { contractAddress, gasPrice, mintPrice, tokenUri }: StartMintArgs,
      { ethers, network }
    ) => {
      const { isAddress, parseEther, formatEther } = ethers.utils;
      if (network.name === 'mainnet') {
        ethers.providers.BaseProvider.prototype.getGasPrice =
          dynamicGetGasPrice('fast');
      }

      assertValidTokenUri(tokenUri, /* dynamic */ true);

      const parsedPrice = parseEther(mintPrice);

      if (parsedPrice < parseEther('0.01')) {
        console.error(
          `mint-price (${formatEther(parsedPrice)} eth) less than 0.01 eth!`
        );
        process.exit(1);
      }

      // prob need to adds spoofiny
      const signer = await ethers.provider.getSigner();

      const parsedContractAddress =
        contractAddress || getContractAddress('ATXDAOUkraineNFT', network.name);
      if (!isAddress(parsedContractAddress)) {
        throw new Error(
          `${parsedContractAddress} is not a valid contract address!`
        );
      }

      const txGasPrice = ethers.BigNumber.from(
        gasPrice || (await ethers.provider.getGasPrice())
      );

      const contract = (await ethers.getContractAt(
        'ATXDAOUkraineNFT',
        parsedContractAddress
      )) as ATXDAOUkraineNFT;

      console.log('   running:  ATXDAONFT_V2.startMint()');
      console.log(`     price:  ${formatEther(parsedPrice)} eth`);
      console.log(`             ${parsedPrice} wei`);
      console.log(`  tokenUri:  ${tokenUri}`);
      console.log(`  contract:  ${parsedContractAddress}`);
      console.log(`   network:  ${network.name}`);
      console.log(`    signer:  ${await signer.getAddress()}`);

      console.log(
        `  gasPrice:  ${ethers.utils.formatUnits(txGasPrice, 'gwei')} gwei\n`
      );

      const tx = await contract.startMint(tokenUri, {
        gasPrice: txGasPrice,
      });

      console.log(`\n  tx hash:   ${tx.hash}`);
    }
  );
