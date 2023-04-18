// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {TokenFactory} from "src/TokenFactory.sol";

// forge script script/DeployFactory.s.sol:DeployFactoryScript --rpc-url $RUS --private-key $PK --broadcast -vvvv

contract DeployFactoryScript is Script {
    bytes32 internal constant SALT = bytes32(abi.encode(0xceeb123));

    address internal admin = 0xD5d1bb95259Fe2c5a84da04D1Aa682C71A1B8C0E;

    function run() public {
        vm.startBroadcast();

        new TokenFactory{salt: SALT}(admin);

        vm.stopBroadcast();
    }
}

/**
Sepolia
TokenFactory 0xb5F6A1320E05BBac9be45f7e2337a5ddB4f36364
KERC20       0xE72dBca5E6fe14C66D054aA9630e5CeA0FEaa736
KERC721      0x1AEd8C6194FD8B93b9D2E5cC47e043d6301252b7
KERC1155     0x7d66aCF37F4C2C8b5E229FAcEB5A40ac8BE9F9d3

// forge verify-contract --verifier-url https://sepolia.etherscan.io/ 0xb5F6A1320E05BBac9be45f7e2337a5ddB4f36364 src/TokenFactory.sol:TokenFactory --constructor-args 0xD5d1bb95259Fe2c5a84da04D1Aa682C71A1B8C0E --etherscan-api-key $EK

// forge verify-contract --chain <CHAIN> --num-of-optimizations <NUM> --watch <ADDRESS> <CONTRACT> [ETHERSCAN_KEY]

// forge verify-contract --chain 11155111 --num-of-optimizations 1000000 --watch 0xFF94CA4D965Da53A070BA1aED50D386E3A4ADe0b src/tokens/KERC20.sol:KERC20 $EK

// forge verify-contract --chain 11155111 --num-of-optimizations 1000000 --watch 0xb5F6A1320E05BBac9be45f7e2337a5ddB4f36364 src/TokenFactory.sol:TokenFactory --constructor-args 0xD5d1bb95259Fe2c5a84da04D1Aa682C71A1B8C0E $EK


 */
