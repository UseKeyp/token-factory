// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {ERC721Upgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Counters} from "lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import {IInitData} from "src/interfaces/IInitData.sol";

contract KERC721 is ERC721Upgradeable, OwnableUpgradeable, IInitData {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    // Max token supply. If zero, infinite token supply
    uint256 public maxSupply;

    // Toggle to disable URI upgradeability
    bool internal immutableUri;

    // Id to token-specific URI
    mapping(uint256 => string) internal tokenURIs;

    event Mint(address recipient, uint256 tokenId);

    /**
     * @dev Initialize, set owner of contract, set supply to infinite or finite
     */
    function initialize(ERC721Data calldata data) external initializer {
        __Ownable_init();
        transferOwnership(data.admin);

        __ERC721_init(data.name, data.symbol);

        if (data.maxSupply > 0) maxSupply = data.maxSupply;
    }

    /**
     * @dev Check if token supply is finite and current supply
     */
    modifier checkSupply() {
        require(
            (maxSupply == 0) || (_tokenIds.current() < maxSupply),
            "Cannot increase token supply"
        );
        _;
    }

    /**
     * @dev Check if URI upgradeability is permitted
     */
    modifier isImmutable() {
        require(!immutableUri, "URIs are immutable");
        _;
    }

    /**
     * @dev Mint token to recipient, increment count, set URI
     */
    function mint(
        address recipient,
        string memory uri
    ) public onlyOwner checkSupply {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, uri);

        emit Mint(recipient, tokenId);
    }

    /**
     * @dev Batch mint token to recipients, increment counts, set URIs
     */
    function batchMint(
        address[] memory recipients,
        string[] memory uris
    ) public {
        uint256 l = recipients.length;
        require(l == uris.length, "Invalid input lengths");

        for (uint256 i = 0; i < l; i++) {
            mint(recipients[i], uris[i]);
        }
    }

    /**
     * @dev Get id of last minted token
     */
    function getTokenId() external view returns (uint256) {
        return _tokenIds.current();
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireMinted(tokenId);
        return tokenURIs[tokenId];
    }

    /**
     * @dev Update token URI. Can be Disabled
     */
    function updateURI(
        uint256 tokenId,
        string memory uri
    ) external onlyOwner isImmutable {
        _setTokenURI(tokenId, uri);
    }

    /**
     * @dev Disabled token URI upgradeability
     */
    function setUriImmutable() external onlyOwner isImmutable {
        immutableUri = true;
    }

    /**
     * @dev Set token URI
     */
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId), "URI set of nonexistent token");
        tokenURIs[tokenId] = uri;
    }
}
