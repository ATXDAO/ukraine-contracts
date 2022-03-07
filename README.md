# ATX DAO Ukraine NFT

## Metadata

### IPFS Metadata

- json
  - 0.0512 eth tier `ipfs://QmcbbDUUTAJoHuPJRXbrRLiSSMBR8vgu4cNaYxAxNsmm3Q/0.json`
  - 0.512 eth tier `ipfs://QmcbbDUUTAJoHuPJRXbrRLiSSMBR8vgu4cNaYxAxNsmm3Q/1.json`
  - 5.12 eth tier `ipfs://QmcbbDUUTAJoHuPJRXbrRLiSSMBR8vgu4cNaYxAxNsmm3Q/2.json`
- image
  - 0.0512 eth tier `ipfs://QmW7V2ULUgqxc1Tkba7PXMiXfnW7UYjHHmvQ9Db67oDT8j/0.png`
  - 0.512 eth tier `ipfs://QmW7V2ULUgqxc1Tkba7PXMiXfnW7UYjHHmvQ9Db67oDT8j/1.png`
  - 5.12 eth tier `ipfs://QmW7V2ULUgqxc1Tkba7PXMiXfnW7UYjHHmvQ9Db67oDT8j/2.png`

### Deployed Contract

- mainnet: [TBD](https://etherscan.io/address/TBD)
- ropsten: [0xa18C3780baCc84ad7585e31EeBCF998631B643cd](https://ropsten.etherscan.io/address/0xa18C3780baCc84ad7585e31EeBCF998631B643cd)
- rinkeby: [0x99390BE7cf40225ECEB7167CA9E3746eCf6D7e6e](https://rinkeby.etherscan.io/address/0x99390BE7cf40225ECEB7167CA9E3746eCf6D7e6e)

## Setup

1. `cp .env.example .env` and set those environment variables
1. install deps via `yarn install`
1. `npm i -g hardhat-shorthand` to install `hh`
1. compile contracts for hardhat tasks `hh compile`

## Testing

1. install [forge](https://github.com/gakonst/foundry)
   - install [rust](https://www.rust-lang.org/tools/install) via
     `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
   - install `foundryup`: `curl https://raw.githubusercontent.com/gakonst/foundry/master/foundryup/install | bash`
   - run `foundryup`
1. `yarn test` in project directory

```zsh
❯ yarn test
yarn run v1.22.17
$ forge clean && forge test -vv && forge clean
Compiling...
Compiling 17 files with 0.8.11
Compiler run successful

Running 1 test for ATXDAOUkraineNFTTest.json:ATXDAOUkraineNFTTest
[PASS] testMintBasic() (gas: 141471)
Done in 1.20s.
```

## Hardhat tasks

### Verify Contract

```zsh
❯ hh verify --contract contracts/ATXDAOUkraineNFT.sol:ATXDAOUkraineNFT --network ropsten --constructor-args constructor-args.js 0xa18C3780baCc84ad7585e31EeBCF998631B643cd
Nothing to compile
No need to generate any newer typings.
Compiling 1 file with 0.8.9
Successfully submitted source code for contract
contracts/ATXDAOUkraineNFT.sol:ATXDAOUkraineNFT at 0xe1e1561881aba2cbb4d29fa4e846c71cbd8073e4
for verification on the block explorer. Waiting for verification result...

Successfully verified contract ATXDAOUkraineNFT on Etherscan.
https://ropsten.etherscan.io/address/0xe1e1561881aba2cbb4d29fa4e846c71cbd8073e4#code
```

### Deploy Contract

```zsh
❯ hh deploy --network hardhat
Nothing to compile
No need to generate any newer typings.
deploying:  ATXDAOUkraineNFT
  network:  hardhat
 deployer:  0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
 gasPrice:  1.875 gwei

deploying "ATXDAOUkraineNFT" (tx: 0x05fa7edbf850e35b97cd8cc7d56968f3666f83a30f54e5bda2cc7b4a5027f41c)...: deployed at 0x5FbDB2315678afecb367f032d93F642f64180aa3 with 2209255 gas
deploy tx:  0x05fa7edbf850e35b97cd8cc7d56968f3666f83a30f54e5bda2cc7b4a5027f41c
  address:  0x5FbDB2315678afecb367f032d93F642f64180aa3
```

```zsh
# use custom gas price
❯ hh gas-price --network mainnet
gas price on mainnet

 current  61692625904 wei
          61.692625904 gwei
    slow  61000000000 wei
          61.0 gwei
standard  61000000000 wei
          61.0 gwei
    fast  61000000000 wei
          61.0 gwei
   rapid  65982650839 wei
          65.982650839 gwei

❯ hh deploy --network ropsten --gas-price 24986498384
deploying:  ATXDAONFT_V2
  network:  ropsten
 deployer:  0x51040CE6FC9b9C5Da69B044109f637dc997e92DE
 gasPrice:  24.986498384 gwei

deploy tx:  0x8148515e0013a6cb9c01863a09e61f5fc1ac79ffb08528342ee04771de0f7e00
  address:  0xe1e1561881aBa2cbb4D29Fa4e846C71CbD8073E4
```
