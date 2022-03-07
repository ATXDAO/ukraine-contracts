import { ATXDAOUkraineNFT } from '../typechain-types/ATXDAOUkraineNFT';
import { getContractAddress, ContractName } from '../util/contract-meta';
import { task } from 'hardhat/config';

interface GetNftOwnersArgs {
  contract: ContractName;
}

task('get-nft-owners', 'gets a list of nft owners, ordered by token id')
  .addParam<ContractName>('contract', 'contract name (e.g. ATXDAOUkraineNFT)')
  .setAction(async ({ contract }: GetNftOwnersArgs, { ethers, network }) => {
    const contractAddress = getContractAddress(contract, network.name);
    const nft = (await ethers.getContractAt(
      contract,
      contractAddress
    )) as ATXDAOUkraineNFT;

    const nftData: { owner: string; tier: number; value: number }[] = [];
    const [owners, tiers, values] = await nft.getOwners();
    owners.forEach((owner, i) =>
      nftData.push({
        owner,
        tier: tiers[i].toNumber(),
        value: values[i].div(1e18).toNumber(),
      })
    );

    console.error(`${nftData.length} found!`);
    console.log(JSON.stringify(nftData, null, 4));
  });
