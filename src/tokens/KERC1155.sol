// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC1155Upgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/ERC1155Upgradeable.sol";

contract KERC1155 is ERC1155Upgradeable {
    function initialize(string memory uri_) external initializer {
        __ERC1155_init(uri_);
    }
}
