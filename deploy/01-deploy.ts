import { FixedDeployFunction } from '../types';
import { ukraineAddress } from '../util/constants';
import { dynamicGetGasPrice } from '../util/gas-now';

const contractName = 'ATXDAOUkraineNFT';

const deployFunc: FixedDeployFunction = async ({
  network,
  ethers,
  deployments,
}) => {
  if (network.name === 'mainnet') {
    ethers.providers.BaseProvider.prototype.getGasPrice =
      dynamicGetGasPrice('fast');
  }

  const signer = await ethers.provider.getSigner();
  const from = await signer.getAddress();
  const deployGasPrice = await ethers.provider.getGasPrice();
  if (!deployGasPrice) {
    throw new Error('deploy gas price undefined!');
  }
  console.log(`deploying:  ${contractName}`);
  console.log(`  network:  ${network.name}`);
  console.log(` deployer:  ${from}`);
  console.log(
    ` gasPrice:  ${ethers.utils.formatUnits(deployGasPrice, 'gwei')} gwei\n`
  );
  const tiers = [
    ethers.utils.parseEther('0.0512'),
    ethers.utils.parseEther('0.512'),
    ethers.utils.parseEther('5.12'),
  ];
  const contract = await deployments.deploy('ATXDAOUkraineNFT', {
    args: [tiers, ukraineAddress],
    libraries: {},
    from,
    log: true,
    autoMine: true,
  });
  console.log('deploy tx: ', contract.receipt?.transactionHash);
  console.log('  address: ', contract.address);
};

deployFunc.id = 'ATXDAOUkraineNFT';

export default deployFunc;
