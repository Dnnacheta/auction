// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract W3bNFT is ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 MAX_SUPPLY = 30;

    constructor() public ERC721("W3BNFT", "W3B") {}

    function mintNFT(address recipient, string memory tokenURI)
        public onlyOwner returns (uint256)
    {
        uint256 Id = _tokenIds.current();
        require(Id <= MAX_SUPPLY, "All 30 W3Bs has been minted already!");
        
        _tokenIds.increment();

        _mint(recipient, Id);
        _setTokenURI(Id, tokenURI);

        return Id;
    }
}