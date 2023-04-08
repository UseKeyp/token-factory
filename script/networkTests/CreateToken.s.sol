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

    bytes32 internal constant SALT = bytes32(abi.encode(0x777));

    function setUp() public {
        createERC20InitData();
        createERC721InitData();
    }

    function run() public {
        vm.startBroadcast();

        factory = new TokenFactory{salt: SALT}();

        factory.deployERC20(444, erc20data);

        vm.stopBroadcast();
    }

    function createERC20InitData() public virtual {
        erc20data.admin = address(this);
        erc20data.recipient = address(this);
        erc20data.initSupply = 100;
        erc20data.name = "Futuro";
        erc20data.symbol = "FTR";
        erc20data.finiteSupply = false;
    }

    function createERC721InitData() public virtual {
        erc721data.admin = address(this);
        erc721data.maxSupply = 100;
        erc721data.name = "Futuro";
        erc721data.symbol = "FTR";
    }
}
