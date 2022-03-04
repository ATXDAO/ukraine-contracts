// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "ds-test/test.sol";
import "contracts/ATXDAOUkraineNFT.sol";
import "./utils/vm.sol";

contract ATXDAOUkraineNFTTest is DSTest {
    // see https://github.com/gakonst/foundry/tree/master/forge
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    address user = address(0x1);
    address to = address(0x2);

    // 1 price tier
    uint256[] tiers1 = new uint256[](1);
    ATXDAOUkraineNFT nft1;

    // 3 price tiers
    uint256[] tiers3 = new uint256[](3);
    ATXDAOUkraineNFT nft3;

    function setUp() public {
        tiers1[0] = .512 ether;
        nft1 = new ATXDAOUkraineNFT(tiers1, to);
        nft1.startMint("ipfs://uri/");

        tiers3[0] = .0512 ether;
        tiers3[1] = .512 ether;
        tiers3[2] = 5.12 ether;
        nft3 = new ATXDAOUkraineNFT(tiers3, to);
        nft1.startMint("ipfs://uri/");
    }

    function testMintBasic() public {
        nft1.startMint("ipfs://uri/");
        vm.deal(user, 1 ether);
        vm.prank(user);
        nft1.mint{value: .512 ether}();
    }
}
