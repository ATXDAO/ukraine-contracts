import { ATXDAOUkraineNFT } from '../typechain-types/ATXDAOUkraineNFT';
import { getContractAddress } from '../util/contract-meta';
import { dynamicGetGasPrice } from '../util/gas-now';
import { task } from 'hardhat/config';

interface MintArgs {
  contractAddress?: string;
  gasPrice?: string;
  mintPrice: string;
}

task<MintArgs>('mint', 'mint an nft')
  .addOptionalParam('contractAddress', 'nftv2 contract address')
  .addOptionalParam(
    'gasPrice',
    'gas price in wei to deploy with (uses provider.getGasPrice() otherwise)'
  )
  .addParam('mintPrice', 'mint price')
  .setAction(
    async (
      { contractAddress, gasPrice, mintPrice }: MintArgs,
      { ethers, network }
    ) => {
      if (network.name === 'mainnet') {
        ethers.providers.BaseProvider.prototype.getGasPrice =
          dynamicGetGasPrice('fast');
      }

      // prob need to adds spoofiny
      const signer = await ethers.provider.getSigner();
      const { isAddress } = ethers.utils;

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

      console.log('   running:  ATXDAOUkraineNFT.mint()');
      console.log(`  contract:  ${parsedContractAddress}`);
      console.log(`   network:  ${network.name}`);
      console.log(`    signer:  ${await signer.getAddress()}`);

      console.log(
        `  gasPrice:  ${ethers.utils.formatUnits(txGasPrice, 'gwei')} gwei\n`
      );

      const tx = await contract.mint({
        value: ethers.utils.parseEther(mintPrice),
        gasPrice: txGasPrice,
      });

      console.log(`\n  tx hash:   ${tx.hash}`);
    }
  );
