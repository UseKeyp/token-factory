// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {TokenFactory} from "src/TokenFactory.sol";
import {IInitData} from "src/interfaces/IInitData.sol";

// GOERLI DEPLOYMENT:
// forge script script/networkTests/CreateToken.s.sol:CreateTokenScript --rpc-url $RUG --private-key $PK --broadcast --verify --etherscan-api-key $EK -vvvv
// forge script script/networkTests/CreateToken.s.sol:CreateTokenScript --rpc-url $RUG --private-key $PK -vvvv

// SEPOLIA DEPLOYMENT:
// forge script script/networkTests/CreateToken.s.sol:CreateTokenScript --rpc-url $RUS --private-key $PK --broadcast --verify --etherscan-api-key $EK -vvvv
// forge script script/networkTests/CreateToken.s.sol:CreateTokenScript --rpc-url $RUS --private-key $PK -vvvv

contract CreateTokenScript is Script, IInitData {
    TokenFactory public factory;
    ERC20Data erc20data;
    ERC721Data erc721data;
    ERC1155Data erc1155data;

    bytes32 internal constant SALT = bytes32(abi.encode(0x777));

    address internal admin = 0xD5d1bb95259Fe2c5a84da04D1Aa682C71A1B8C0E;

    function setUp() public {
        createInitData();
    }

    function run() public {
        vm.startBroadcast();

        factory = new TokenFactory{salt: SALT}(admin);

        factory.deployERC20(0x111, erc20data);
        factory.deployERC721(0x2222, erc721data);
        factory.deployERC1155(0x3333, erc1155data);

        vm.stopBroadcast();
    }

    function createInitData() public virtual {
        erc20data.admin = address(this);
        erc20data.recipient = address(this);
        erc20data.initSupply = 100;
        erc20data.name = "Futuro";
        erc20data.symbol = "FTR";
        erc20data.finiteSupply = false;

        erc721data.admin = address(this);
        erc721data.maxSupply = 100;
        erc721data.name = "Futuro";
        erc721data.symbol = "FTR";

        erc1155data.admin = address(this);
        erc1155data.name = "Futuro";
        erc1155data.symbol = "FTR";
        erc1155data.uri = "xyz";
    }
}

/**
 * SEPOLIA DEPLOYMENT:
 * factory -
 * erc20   -
 * erc721  -
 * erc1155 -
 *
 * GOERLI  DEPLOYMENT:
 * factory - 0xBF504F2278E153cB991186167E415D9081798F7C
 * erc20   - 0x3dcCD21691c24B3344BC86d6358FF87b30EB4dFE
 * erc721  - 0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519
 * erc1155 - 0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519
 */
