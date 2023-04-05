// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Clones} from "lib/openzeppelin-contracts/contracts/proxy/Clones.sol";
import {KERC20} from "src/tokens/KERC20.sol";
import {KERC721} from "src/tokens/KERC721.sol";
import {KERC1155} from "src/tokens/KERC1155.sol";

contract TokenFactory {
    KERC20 public kerc20;
    KERC721 public kerc721;
    KERC1155 public kerc1155;

    constructor() {
        // deploy singletons
        kerc20 = KERC20(new KERC20());
        kerc721 = KERC20(new KERC721());
        kerc1155 = KERC20(new KERC1155());
    }

    function deployERC20() external returns (address) {
        address clone = Clones.clone(kerc20);
        KERC20(clone).initialize();
        return clone;
    }

    function deployERC721() external returns (address) {
        address clone = Clones.clone(kerc721);
        KERC721(clone).initialize();
        return clone;
    }

    function deployERC1155() external returns (address) {
        address clone = Clones.clone(kerc1155);
        KERC1155(clone).initialize();
        return clone;
    }

    // token: 1 = ERC20, 2 = ERC721, 3 = ERC1155
    function upgradeSingleton(uint256 token, address singleton) external {
        require(token > 0 && token <= 3, "Token selector out of range!");

        if (token == 1) {
            kerc20 = singleton;
        } else if (token == 2) {
            kerc721 = singleton;
        } else {
            kerc1155 = singleton;
        }
    }
}
