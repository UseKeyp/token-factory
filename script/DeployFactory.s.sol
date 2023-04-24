// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "forge-std/Script.sol";
import {TokenFactory} from "src/TokenFactory.sol";
import {KERC20} from "src/tokens/KERC20.sol";
import {KERC721} from "src/tokens/KERC721.sol";
import {KERC1155} from "src/tokens/KERC1155.sol";

/**
DEPLOY SCRIPT EXAMPLE:
    forge script script/DeployFactory.s.sol:DeployFactoryScript --rpc-url $RUP --private-key $PK --broadcast -vvvv

VERIFY SCRIPT EXAMPLE:
  forge verify-contract --chain 137 --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" --constructor-args $(cast abi-encode "constructor(address)" 0x7AE1F70f92B2A54606e47737CCeE241D3E21DA83) 0xba14cf308A380b75D6bb4F7E73C6603b14c2F3CE TokenFactory $ETHERSCAN_API_KEY

  forge verify-contract --chain 137 --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" 0x34f22aa96d5abd0a8f371d1f18f909a002ca4062 KERC20 $POLYGONSCAN_KEY

  forge verify-contract --chain 137 --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" 0xdec7bbe031a7e43fb1104fa3bd6d112141bc86ac KERC721 $POLYGONSCAN_KEY

  forge verify-contract --chain 137 --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" 0x9c8ee8d84cae1b3e8e725da096097273b4911b32 KERC1155 $POLYGONSCAN_KEY
*/

contract DeployFactoryScript is Script {
    /**
     * @dev change this SALT for each deployment on the SAME network to avoid collisions
     * keep the same SALT for different networks to maintain same multi-chain address
     */
    bytes32 internal constant SALT = bytes32(abi.encode(0xcafca));

    // factory Admin for version upgrades
    address internal admin = 0x7AE1F70f92B2A54606e47737CCeE241D3E21DA83;

    function run() public {
        vm.startBroadcast();

        // deploy factory with CREATE2
        new TokenFactory{salt: SALT}(admin);

        vm.stopBroadcast();
    }
}
