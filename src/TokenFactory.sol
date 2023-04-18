// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import {AccessControl} from "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import {IInitData} from "src/interfaces/IInitData.sol";
import {KERC20} from "src/tokens/KERC20.sol";
import {KERC721} from "src/tokens/KERC721.sol";
import {KERC1155} from "src/tokens/KERC1155.sol";

contract TokenFactory is IInitData, AccessControl {
    // Access control admin
    bytes32 public constant ADMIN = keccak256("ADMIN");

    // Creation bytecode of token contracts
    bytes kerc20;
    bytes kerc721;
    bytes kerc1155;

    event DeployedToken(address tokenAddress, uint256 salt);

    /**
     * @dev Deploy singletons for verification on clone deployments,
     * get creation bytecode of token contracts, add admin
     */
    constructor(address administrator) {
        kerc20 = type(KERC20).creationCode;
        kerc721 = type(KERC721).creationCode;
        kerc1155 = type(KERC1155).creationCode;

        _grantRole(ADMIN, administrator);
    }

    /**
     * @dev Deploy ERC20, ERC721, and ERC155 contracts
     */
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
        ERC1155Data calldata data
    ) external returns (address clone) {
        clone = deploy(kerc1155, salt);
        KERC1155(clone).initialize(data);
    }

    /**
     * @dev deploy contract with CREATE2 opcode
     */
    function deploy(
        bytes memory bytecode,
        uint256 salt
    ) internal returns (address addr) {
        assembly {
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
     * @dev Upgrade the token contract bytecode
     * ContractId: 1 = ERC20, 2 = ERC721, 3 = ERC1155
     */
    function upgradeSingleton(
        uint256 contractId,
        bytes calldata creationBytecode
    ) external onlyRole(ADMIN) {
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
