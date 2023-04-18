// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20Upgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {IInitData} from "src/interfaces/IInitData.sol";

contract KERC20 is ERC20Upgradeable, OwnableUpgradeable, IInitData {
    // Infinite or finite token suppply
    bool internal infiniteSupply;

    event Mint(address recipient, uint256 amount);

    /**
     * @dev Initialize, set owner of contract, set supply to infinite or finite
     */
    function initialize(ERC20Data calldata data) external initializer {
        __Ownable_init();
        transferOwnership(data.admin);

        __ERC20_init(data.name, data.symbol);

        if (data.infiniteSupply) infiniteSupply = true;
        _mint(data.recipient, data.initSupply);
    }

    /**
     * @dev Mint token to recipient
     */
    function mint(address recipient, uint256 amount) external onlyOwner {
        require(infiniteSupply, "Cannot increase token supply");
        _mint(recipient, amount);
        emit Mint(recipient, amount);
    }
}
