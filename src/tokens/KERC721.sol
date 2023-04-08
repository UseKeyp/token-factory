// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721Upgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Counters} from "lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import {IInitData} from "src/interfaces/IInitData.sol";

contract KERC721 is ERC721Upgradeable, OwnableUpgradeable, IInitData {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    address public _owner;
    uint256 public maxSupply;
    bool internal immutableUri;

    mapping(uint256 => string) internal tokenURIs;

    event Mint(address caller, uint256 tokenId);

    modifier checkSupply() {
        // if maxSupply is zero, maxSupply = infinite
        require(
            (maxSupply == 0) || (_tokenIds.current() < maxSupply),
            "Cannot increase token supply"
        );
        _;
    }

    modifier isImmutable() {
        require(!immutableUri, "URIs are immutable");
        _;
    }

    function initialize(ERC721Data calldata data) external initializer {
        // set admin of contract
        __Ownable_init();
        transferOwnership(data.admin);

        __ERC721_init(data.name, data.symbol);

        // set infinite or finite token suppply
        if (data.maxSupply > 0) maxSupply = data.maxSupply;
    }

    function mint(
        address recipient,
        string memory uri
    ) external onlyOwner checkSupply {
        // increment token id
        _tokenIds.increment();
        uint256 id = _tokenIds.current();

        // mint token to caller
        _safeMint(recipient, id);

        // set token uri
        _setTokenURI(id, uri);

        emit Mint(recipient, id);
    }

    function getTokenId() external view returns (uint256) {
        return _tokenIds.current();
    }

    function updateUri(
        uint256 id,
        string memory uri
    ) external onlyOwner isImmutable {
        // update token uri
        _setTokenURI(id, uri);
    }

    function setUriImmutable() external onlyOwner isImmutable {
        immutableUri = true;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireMinted(tokenId);
        return tokenURIs[tokenId];
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        tokenURIs[tokenId] = uri;
    }
}
