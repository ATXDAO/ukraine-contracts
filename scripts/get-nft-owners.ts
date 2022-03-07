import { ATXDAOUkraineNFT } from '../typechain-types/ATXDAOUkraineNFT';
import { getContractAddress } from '../util/contract-meta';
import { BigNumber } from 'ethers';
import { task } from 'hardhat/config';

task(
  'get-nft-owners',
  'gets a list of nft owners, ordered by token id'
).setAction(async ({}, { ethers, network }) => {
  const contractAddress = getContractAddress('ATXDAOUkraineNFT', network.name);
  const nft = (await ethers.getContractAt(
    'ATXDAOUkraineNFT',
    contractAddress
  )) as ATXDAOUkraineNFT;

  const nftData: { owner: string; tier: number; value: string }[] = [];
  const [owners, tiers, values] = await nft.getOwners();
  owners.forEach((owner, i) =>
    nftData.push({
      owner,
      tier: tiers[i].toNumber(),
      value: values[i].toString(),
    })
  );

  console.error(`${nftData.length} found!`);
  console.log(JSON.stringify(nftData, null, 4));
});
