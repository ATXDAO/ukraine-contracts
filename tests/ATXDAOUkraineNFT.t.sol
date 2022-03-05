// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "ds-test/test.sol";
import "contracts/ATXDAOUkraineNFT.sol";
import "./utils/vm.sol";

contract ATXDAOUkraineNFTTest is DSTest {
    // see https://github.com/gakonst/foundry/tree/master/forge
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    address user = address(0x1);
    address mainRecip = address(0x2);
    address altRecip = address(0x3);

    // 3 price tiers
    uint256[] tiers = new uint256[](3);
    ATXDAOUkraineNFT nft;

    string BASE_TOKEN_URI = "ipfs://uri/";

    function setUp() public {
        tiers[0] = .0512 ether;
        tiers[1] = .512 ether;
        tiers[2] = 5.12 ether;
        nft = new ATXDAOUkraineNFT(tiers, mainRecip);
        nft.startMint(BASE_TOKEN_URI);
        vm.deal(user, 100 ether);
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
        vm.startPrank(user);

        vm.expectRevert("value smaller than lowest tier!");
        nft.mint{value: .01 ether}(mainRecip);

        nft.mint{value: .0512 ether}(mainRecip);
        assertEq(nft.tokenURI(1), "ipfs://uri/0.json");

        nft.mint{value: .512 ether}(mainRecip);
        assertEq(nft.tokenURI(2), "ipfs://uri/1.json");

        nft.mint{value: 8 ether}(mainRecip);
        assertEq(nft.tokenURI(3), "ipfs://uri/2.json");

        assertEq(mainRecip.balance, 8.5632 ether);
        assertEq(address(nft).balance, 0);

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

    function testStartMint() public {
        ATXDAOUkraineNFT nft2 = new ATXDAOUkraineNFT(tiers, mainRecip);
        assert(!nft2.isMintable());

        vm.prank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        nft2.startMint(BASE_TOKEN_URI);

        nft2.startMint(BASE_TOKEN_URI);
        assert(nft2.isMintable());
    }

    function testEndMint() public {
        vm.prank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        nft.endMint();

        nft.endMint();
        vm.expectRevert("minting not started!");
        nft.mint{value: .512 ether}(mainRecip);
    }

    function testGetTier() public {
        vm.expectRevert("value smaller than lowest tier!");
        nft.getTier(0.01 ether);
        assertEq(nft.getTier(0.0512 ether), 0);
        assertEq(nft.getTier(0.512 ether), 1);
        assertEq(nft.getTier(5.12 ether), 2);
        assertEq(nft.getTier(512 ether), 2);
    }

    function testAltRecips() public {
        vm.prank(user);
        vm.expectRevert("recipient not whitelisted!");
        nft.mint{value: .0512 ether}(altRecip);

        nft.addRecip(altRecip);
        vm.prank(user);
        nft.mint{value: .0512 ether}(altRecip);
        assertEq(altRecip.balance, .0512 ether);
    }
}
