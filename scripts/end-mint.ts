import { ATXDAOUkraineNFT } from '../typechain-types/ATXDAOUkraineNFT';
import { getContractAddress } from '../util/contract-meta';
import { dynamicGetGasPrice } from '../util/gas-now';
import { task } from 'hardhat/config';

interface EndMintArgs {
  contractAddress?: string;
  gasPrice?: string;
}

task<EndMintArgs>('end-mint', 'ends mint')
  .addOptionalParam('contractAddress', 'nftv2 contract address')
  .addOptionalParam(
    'gasPrice',
    'gas price in wei to deploy with (uses provider.getGasPrice() otherwise)'
  )
  .setAction(
    async ({ contractAddress, gasPrice }: EndMintArgs, { ethers, network }) => {
      const { isAddress } = ethers.utils;
      if (network.name === 'mainnet') {
        ethers.providers.BaseProvider.prototype.getGasPrice =
          dynamicGetGasPrice('fast');
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

      console.log('   running:  ATXDAOUkraineNFT.endMint()');
      console.log(`  contract:  ${parsedContractAddress}`);
      console.log(`   network:  ${network.name}`);
      console.log(`    signer:  ${await signer.getAddress()}`);

      console.log(
        `  gasPrice:  ${ethers.utils.formatUnits(txGasPrice, 'gwei')} gwei\n`
      );

      const tx = await contract.endMint({
        gasPrice: txGasPrice,
      });

      console.log(`\n  tx hash:   ${tx.hash}`);
    }
  );
