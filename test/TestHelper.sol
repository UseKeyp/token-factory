// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "forge-std/Test.sol";
import {TokenFactory} from "src/TokenFactory.sol";
import {IInitData} from "src/interfaces/IInitData.sol";

// forge test --match-contract TestHelper -vv

contract TestHelper is Test, IInitData {
    uint256 public constant SALT1 = 0x1111;
    uint256 public constant SALT2 = 0x2222;
    uint256 public constant SALT3 = 0x3333;

    TokenFactory public factory;
    address admin = 0xD5d1bb95259Fe2c5a84da04D1Aa682C71A1B8C0E;

    address deployer = address(this);
    address alice = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address bob = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address charlie = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

    function setUp() public virtual {
        factory = new TokenFactory(admin);

        emit log_named_address("Factory:", address(factory));
    }
}
