// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20Upgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {IInitData} from "src/interfaces/IInitData.sol";

contract KERC20 is ERC20Upgradeable, OwnableUpgradeable, IInitData {
    address public _owner;
    bool internal finiteSupply;

    modifier checkSupply() {
        require(!finiteSupply, "Cannot increase token supply");
        _;
    }

    function initialize(ERC20Data calldata data) external initializer {
        // set admin of contract
        __Ownable_init();
        transferOwnership(data.admin);

        // initialize ERC20 token
        __ERC20_init(data.name, data.symbol);

        // set infinite or finite token suppply
        if (data.finiteSupply) finiteSupply = true;

        // mint initial or total token supplyx
        _mint(data.recipient, data.initSupply);
    }

    function mint(
        address recipient,
        uint256 amount
    ) external onlyOwner checkSupply {
        _mint(recipient, amount);
    }
}
