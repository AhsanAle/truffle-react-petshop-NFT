//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTERC721 is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => address) private _tokenOwners;

    string private _baseURIextended;

    constructor() ERC721("Q4", "$Q") {
        _baseURIextended = "https://ipfs.infura.io/ipfs/";
    }

    event LogString(address, uint256);

    fallback() external payable {
        require(msg.value > 0, "No Ethers Found");
        emit LogString(msg.sender, msg.value);
        payable(owner()).transfer(msg.value);
    }

    receive() external payable {
        require(msg.value > 0, "No Ethers Found");
        payable(owner()).transfer(msg.value);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexisten token"
        );
        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        return string(abi.encodePacked(base, _tokenURI));
    }

    function mintNFT(string memory imgHash) public {
        require(msg.sender != address(0), "sender cannot be zero address");

        uint256 newTokenId = tokenIds.current();
        _mint(owner(), newTokenId);
        emit LogString(msg.sender, newTokenId);
        _tokenURIs[newTokenId] = imgHash;
        tokenURI(newTokenId);
        tokenIds.increment();
        _tokenOwners[newTokenId] = owner();
    }

    function totalSupply() external view returns (uint256) {
        return tokenIds.current();
    }

    function adoptPetNft(uint256 tokenId) public payable returns (uint256) {
        require(msg.sender != address(0), "Address of Sender cannot be zero");
        require(msg.value > 0, "No Ethers Found");
        payable(owner()).transfer(msg.value);
        _tokenOwners[tokenId] = msg.sender;
        _transfer(ownerOf(tokenId), msg.sender, tokenId);
        return tokenId;
    }
}
