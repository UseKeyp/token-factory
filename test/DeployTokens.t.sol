// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "test/TestHelper.sol";

// forge test --match-contract DeployTokensTest -vvvv

contract DeployTokensTest is TestHelper {
    ERC20Data public erc20data;
    ERC721Data public erc721data;
    ERC1155Data public erc1155data;

    function testDeployTokens() public {
        createInitData();

        address clone20 = factory.deployERC20(SALT1, erc20data);
        emit log_named_address("Clone:", clone20);

        address clone721 = factory.deployERC721(SALT2, erc721data);
        emit log_named_address("Clone:", clone721);

        address clone1155 = factory.deployERC1155(SALT3, erc1155data);
        emit log_named_address("Clone:", clone1155);
    }

    function createInitData() public virtual {
        // erc20 init data
        erc20data.admin = address(this);
        erc20data.recipient = address(this);
        erc20data.initSupply = 100;
        erc20data.name = "Futuro";
        erc20data.symbol = "FTR";
        erc20data.infiniteSupply = false;

        // erc721 init data
        erc721data.admin = address(this);
        erc721data.maxSupply = 100;
        erc721data.name = "Futuro";
        erc721data.symbol = "FTR";

        // erc20 init data
        erc1155data.admin = address(this);
        erc1155data.name = "Futuro";
        erc1155data.symbol = "FTR";
        erc1155data.uri = "";
    }
}
