// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {TokenFactory} from "src/TokenFactory.sol";

// forge script script/CreateToken.s.sol:CreateTokenScript --rpc-url $RUG --private-key $PK --broadcast --verify --etherscan-api-key $EK -vvvv

contract CreateTokenScript is Script {
    TokenFactory public factory;

    bytes32 internal constant SALT = bytes32(abi.encode(0xceeb));

    function run() public {
        vm.startBroadcast();

        factory = new TokenFactory{salt: SALT}();

        vm.stopBroadcast();
    }
}
