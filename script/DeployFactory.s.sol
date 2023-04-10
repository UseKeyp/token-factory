// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {TokenFactory} from "src/TokenFactory.sol";

// forge script script/DeployFactory.s.sol:DeployFactoryScript --rpc-url $RUS --private-key $PK --broadcast --verify --etherscan-api-key $EK -vvvv

contract DeployFactoryScript is Script {
    bytes32 internal constant SALT = bytes32(abi.encode(0xceeb));

    address internal admin = 0xD5d1bb95259Fe2c5a84da04D1Aa682C71A1B8C0E;

    function run() public {
        vm.startBroadcast();

        new TokenFactory{salt: SALT}(admin);

        vm.stopBroadcast();
    }
}
