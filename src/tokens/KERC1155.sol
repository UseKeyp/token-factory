// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC1155Upgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/ERC1155Upgradeable.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Counters} from "lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import {IInitData} from "src/interfaces/IInitData.sol";

contract KERC1155 is ERC1155Upgradeable, OwnableUpgradeable, IInitData {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    // Token contract name
    string public name;

    // Token contract symbol
    string public symbol;

    // Toggle to disable URI upgradeability
    bool internal immutableUri;

    // Token id => max supply (if zero, supply is infinite)
    mapping(uint256 => uint256) public maxSupply;

    // Token id => current supply
    mapping(uint256 => uint256) internal currentSupply;

    event Mint(address recipient, uint256 tokenId, uint256 amount);

    /**
     * @dev Initialize, set owner of contract, map token ids to names
     */
    function initialize(ERC1155Data calldata data) external initializer {
        __Ownable_init();
        transferOwnership(data.admin);

        __ERC1155_init(data.uri);

        name = data.name;
        symbol = data.symbol;
    }

    /**
     * @dev Check if token supply is finite and current supply
     */
    modifier checkSupply(uint256 tokenId, uint256 amount) {
        uint256 toMint = currentSupply[tokenId] + amount;
        uint256 max = maxSupply[tokenId];
        require((max == 0) || (toMint <= max), "Cannot increase token supply");
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
     * @dev Mint token(s) to recipient, increment count
     */
    function mint(
        address recipient,
        uint256 tokenId,
        uint256 amount
    ) public onlyOwner checkSupply(tokenId, amount) {
        uint256 current = currentSupply[tokenId];

        require(current > 0, "Token id is nonexistent");

        currentSupply[tokenId] = current + amount;

        _mint(recipient, tokenId, amount, "");
        emit Mint(recipient, tokenId, amount);
    }

    /**
     * @dev Batch mint token(s) to recipients, increment counts
     */
    function batchMint(
        address[] memory recipients,
        uint256[] memory tokenIds,
        uint256[] memory amounts
    ) public {
        uint256 l = recipients.length;
        require(
            (l == tokenIds.length) && (l == amounts.length),
            "Invalid input lengths"
        );

        for (uint256 i = 0; i < l; i++) {
            mint(recipients[i], tokenIds[i], amounts[i]);
        }
    }

    /**
     * @dev Create and mint token(s) to recipient, increment count
     */
    function createAndMint(
        address recipient,
        uint256 amount,
        uint256 _maxSupply
    ) external onlyOwner {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        currentSupply[tokenId] = amount;

        if (_maxSupply > 0) maxSupply[tokenId] = _maxSupply;

        _mint(recipient, tokenId, amount, "");
    }

    /**
     * @dev Get id of last minted token
     */
    function getTokenId() external view returns (uint256) {
        return _tokenIds.current();
    }

    /**
     * @dev Update token URI. Can be Disabled
     */
    function updateURI(string memory uri) external onlyOwner isImmutable {
        _setURI(uri);
    }

    /**
     * @dev Disabled token URI upgradeability
     */
    function setUriImmutable() external onlyOwner isImmutable {
        immutableUri = true;
    }
}
