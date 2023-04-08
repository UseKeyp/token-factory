// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {TokenFactory} from "src/TokenFactory.sol";
import {IInitData} from "src/interfaces/IInitData.sol";

// forge test --match-contract CreateTokensTest -vvvv

contract CreateTokensTest is Test, IInitData {
    TokenFactory public factory;
    ERC20Data erc20data;
    ERC721Data erc721data;

    function setUp() public {
        factory = new TokenFactory();
        emit log_named_address("Factory:", address(factory));

        createERC20InitData();
        createERC721InitData();
    }

    function testPredictAddress() public {
        address clone20 = factory.deployERC20(333, erc20data);
        emit log_named_address("Clone:", clone20);

        address clone721 = factory.deployERC721(333, erc721data);
        emit log_named_address("Clone:", clone721);
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
