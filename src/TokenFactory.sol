// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IInitData} from "src/interfaces/IInitData.sol";
import {KERC20} from "src/tokens/KERC20.sol";
import {KERC721} from "src/tokens/KERC721.sol";
import {KERC1155} from "src/tokens/KERC1155.sol";

contract TokenFactory is IInitData {
    bytes kerc20;
    bytes kerc721;
    bytes kerc1155;

    event DeployedToken(address token, uint256 salt);

    constructor() {
        // get creation bytecode of token contracts
        kerc20 = type(KERC20).creationCode;
        kerc721 = type(KERC721).creationCode;
        kerc1155 = type(KERC1155).creationCode;
    }

    function deployERC20(
        uint256 salt,
        ERC20Data calldata data
    ) external returns (address clone) {
        clone = deploy(kerc20, salt);
        KERC20(clone).initialize(data);
    }

    function deployERC721(
        uint256 salt,
        ERC721Data calldata data
    ) external returns (address clone) {
        clone = deploy(kerc721, salt);
        KERC721(clone).initialize(data);
    }

    function deployERC1155(
        uint256 salt,
        string memory uri
    ) external returns (address clone) {
        clone = deploy(kerc1155, salt);
        KERC1155(clone).initialize(uri);
    }

    function deploy(
        bytes memory bytecode,
        uint256 salt
    ) public payable returns (address addr) {
        assembly {
            // create2(v = ETH, p = pointer start, n = size of code, s = salt)
            addr := create2(
                callvalue(),
                add(bytecode, 0x20),
                mload(bytecode),
                salt
            )
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
        emit DeployedToken(addr, salt);
    }

    /**
     * upgrade the token contract bytecode
     * contractId: 1 = ERC20, 2 = ERC721, 3 = ERC1155
     */
    function upgradeSingleton(
        uint256 contractId,
        bytes calldata creationBytecode
    ) external {
        require(
            contractId > 0 && contractId <= 3,
            "Token selector out of range"
        );

        if (contractId == 1) {
            kerc20 = creationBytecode;
        } else if (contractId == 2) {
            kerc721 = creationBytecode;
        } else {
            kerc1155 = creationBytecode;
        }
    }
}
