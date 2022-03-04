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

    // 3 price tiers
    uint256[] tiers = new uint256[](3);
    ATXDAOUkraineNFT nft;

    function setUp() public {
        tiers[0] = .0512 ether;
        tiers[1] = .512 ether;
        tiers[2] = 5.12 ether;
        nft = new ATXDAOUkraineNFT(tiers, to);
        nft.startMint("ipfs://uri/");
    }

    function testSetTiers() public {
        uint256[] memory emptyTiers;
        vm.expectRevert("must be at least 1 price tier");
        nft.setTiers(emptyTiers);

        uint256[] memory descTiers = new uint256[](2);
        descTiers[0] = 2;
        descTiers[1] = 1;
        vm.expectRevert("price tiers not ascending!");
        nft.setTiers(descTiers);
    }

    function testMintBasic() public {
        nft.startMint("ipfs://uri/");
        vm.deal(user, 10 ether);
        vm.startPrank(user);

        vm.expectRevert("value smaller than lowest tier!");
        nft.mint{value: .01 ether}();

        nft.mint{value: .0512 ether}();
        assertEq(nft.tokenURI(1), "ipfs://uri/0.json");

        nft.mint{value: .512 ether}();
        assertEq(nft.tokenURI(2), "ipfs://uri/1.json");

        nft.mint{value: 8 ether}();
        assertEq(nft.tokenURI(3), "ipfs://uri/2.json");

        assertEq(to.balance, 8.5632 ether);

        (
            address[] memory owners,
            uint256[] memory ownerTiers,
            uint256[] memory values
        ) = nft.getOwners();
        assertEq(owners.length, 3);
        for (uint256 i = 0; i < owners.length; ++i) {
            assertEq(owners[i], user);
            assertEq(ownerTiers[i], i);
        }
        assertEq(values[2], 8 ether);
    }

    function testEndMint() public {
        nft.endMint();
        vm.expectRevert("minting not started!");
        nft.mint{value: .512 ether}();
    }

    function testGetTier() public {
        vm.expectRevert("value smaller than lowest tier!");
        nft.getTier(0.01 ether);
        assertEq(nft.getTier(0.0512 ether), 0);
        assertEq(nft.getTier(0.512 ether), 1);
        assertEq(nft.getTier(5.12 ether), 2);
        assertEq(nft.getTier(512 ether), 2);
    }
}
