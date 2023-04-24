// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "forge-std/Script.sol";
import {TokenFactory} from "src/TokenFactory.sol";
import {KERC20} from "src/tokens/KERC20.sol";
import {KERC721} from "src/tokens/KERC721.sol";
import {KERC1155} from "src/tokens/KERC1155.sol";

/**
DEPLOY SCRIPT EXAMPLE:
    forge script script/DeployTokens.s.sol:DeployTokensScript --rpc-url $RUP --private-key $PK --broadcast -vvvv

VERIFY SCRIPT EXAMPLE:
  forge verify-contract --chain 11155111 --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" --constructor-args $(cast abi-encode "constructor(address)" 0xD5d1bb95259Fe2c5a84da04D1Aa682C71A1B8C0E) 0x5adD3B692A13a42132c17a7e94DF3193ca108a74 TokenFactory $POLYGONSCAN_KEY

  forge verify-contract --chain 11155111 --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" 0x34f22aa96d5abd0a8f371d1f18f909a002ca4062 KERC20 $POLYGONSCAN_KEY

  forge verify-contract --chain 11155111 --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" 0xdec7bbe031a7e43fb1104fa3bd6d112141bc86ac KERC721 $POLYGONSCAN_KEY

  forge verify-contract --chain 11155111 --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" 0x9c8ee8d84cae1b3e8e725da096097273b4911b32 KERC1155 $POLYGONSCAN_KEY
*/

contract DeployTokensScript is Script {
    function run() public {
        vm.startBroadcast();
        // deploy singletons with CREATE (MUST verify, so all subsequent user token deployments with CREATE2 are auto-verified)
        new KERC20();
        new KERC721();
        new KERC1155();

        vm.stopBroadcast();
    }
}
