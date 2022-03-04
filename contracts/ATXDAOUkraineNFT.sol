/*
  /$$$$$$  /$$$$$$$$ /$$   /$$ /$$$$$$$   /$$$$$$   /$$$$$$
 /$$__  $$|__  $$__/| $$  / $$| $$__  $$ /$$__  $$ /$$__  $$
| $$  \ $$   | $$   |  $$/ $$/| $$  \ $$| $$  \ $$| $$  \ $$
| $$$$$$$$   | $$    \  $$$$/ | $$  | $$| $$$$$$$$| $$  | $$
| $$__  $$   | $$     >$$  $$ | $$  | $$| $$__  $$| $$  | $$
| $$  | $$   | $$    /$$/\  $$| $$  | $$| $$  | $$| $$  | $$
| $$  | $$   | $$   | $$  \ $$| $$$$$$$/| $$  | $$|  $$$$$$/
|__/  |__/   |__/   |__/  |__/|_______/ |__/  |__/ \______/
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ATXDAOUkraineNFT is ERC721URIStorage, Ownable {
    using Strings for uint256;

    bool public isMintable = false;

    uint256 public _tokenId = 0;

    uint256[] public priceTiers;

    string private baseURI;
    address payable public to;

    mapping(uint256 => uint256) public tierMap;
    mapping(uint256 => uint256) public valueMap;

    event UkraineNFTMinted(address recip, uint256 value, uint256 tier);

    constructor(uint256[] memory _priceTiers, address _to)
        ERC721("ATX <3 UKR", "ATX <3 UKR")
    {
        setTiers(_priceTiers);
        to = payable(_to);
    }

    function setTiers(uint256[] memory _priceTiers) public onlyOwner {
        require(_priceTiers.length > 0, "must be at least 1 price tier");
        priceTiers = new uint256[](_priceTiers.length);
        priceTiers[0] = _priceTiers[0];
        for (uint256 i = 1; i < _priceTiers.length; ++i) {
            require(
                _priceTiers[i] > _priceTiers[i - 1],
                "price tiers not ascending!"
            );
            priceTiers[i] = _priceTiers[i];
        }
    }

    function getTier(uint256 value) public view returns (uint256) {
        require(value >= priceTiers[0], "value smaller than lowest tier!");
        uint256 tier = 0;
        for (uint256 i = 0; i < priceTiers.length; ++i) {
            if (value < priceTiers[i]) {
                break;
            }
            tier = i;
        }
        return tier;
    }

    // Normal mint
    function mint() external payable {
        require(
            isMintable == true,
            "ATX DAO Ukraine NFT is not mintable at the moment!"
        );
        // returns a tier or throws an error if value too small
        uint256 tier = getTier(msg.value);

        _tokenId += 1;
        _safeMint(msg.sender, _tokenId);
        _setTokenURI(
            _tokenId,
            string(abi.encodePacked(baseURI, tier.toString(), ".json"))
        );
        to.transfer(msg.value);
        tierMap[_tokenId] = tier;
        valueMap[_tokenId] = msg.value;
        emit UkraineNFTMinted(msg.sender, msg.value, tier);
    }

    function startMint(string memory tokenURI) public onlyOwner {
        baseURI = tokenURI;
        isMintable = true;
    }

    function endMint() public onlyOwner {
        isMintable = false;
    }

    function getOwners()
        public
        view
        returns (
            address[] memory owners,
            uint256[] memory tiers,
            uint256[] memory values
        )
    {
        owners = new address[](_tokenId);
        tiers = new uint256[](_tokenId);
        values = new uint256[](_tokenId);
        for (uint256 i = 0; i < _tokenId; ++i) {
            owners[i] = ownerOf(i + 1);
            tiers[i] = tierMap[i + 1];
            values[i] = valueMap[i + 1];
        }
        return (owners, tiers, values);
    }
}
