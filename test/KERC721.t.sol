// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "test/TestHelper.sol";
import {KERC721} from "src/tokens/KERC721.sol";

// forge test --match-contract KERC721Test -vv

contract KERC721Test is TestHelper {
    ERC721Data public data1;
    ERC721Data public data2;

    KERC721 public token1;
    KERC721 public token2;

    function setUp() public override {
        factory = new TokenFactory(admin);
        createInitData();

        token1 = KERC721(factory.deployERC721(SALT1, data1));
        token2 = KERC721(factory.deployERC721(SALT2, data2));
    }

    /**
     * @dev Only admin should be able to mint
     */
    function testMintPermissions() public {
        vm.startPrank(alice);

        token1.mint(bob, "");

        uint256 Abal = token1.balanceOf(alice);
        assertEq(Abal, 0);

        uint256 Bbal = token1.balanceOf(bob);
        assertEq(Bbal, 1);

        vm.stopPrank();
    }

    /**
     * @dev Non-admin should not be able to mint
     */
    function testMintPermissionsFail() public {
        vm.startPrank(bob);

        vm.expectRevert("Ownable: caller is not the owner");
        token1.mint(alice, "");

        uint256 Abal = token1.balanceOf(alice);
        assertEq(Abal, 0);

        uint256 Bbal = token1.balanceOf(bob);
        assertEq(Bbal, 0);

        vm.stopPrank();
    }

    /**
     * @dev Infinite token supply should allow mint
     */
    function testInfiniteMint() public {
        vm.startPrank(alice);

        address[] memory recipients = new address[](3);
        string[] memory uris = new string[](3);

        recipients[0] = alice;
        recipients[1] = bob;
        recipients[2] = charlie;

        uris[0] = "x";
        uris[1] = "y";
        uris[2] = "z";

        token1.batchMint(recipients, uris);

        uint256 Abal = token1.balanceOf(alice);
        assertEq(Abal, 1);

        uint256 Bbal = token1.balanceOf(bob);
        assertEq(Bbal, 1);

        uint256 Cbal = token1.balanceOf(charlie);
        assertEq(Cbal, 1);

        vm.stopPrank();
    }

    /**
     * @dev Finite token supply should not allow mint
     */
    function testFiniteMintFail() public {
        vm.startPrank(bob);

        address[] memory recipients = new address[](3);
        string[] memory uris = new string[](3);

        recipients[0] = alice;
        recipients[1] = bob;
        recipients[2] = charlie;

        uris[0] = "x";
        uris[1] = "y";
        uris[2] = "z";

        vm.expectRevert("Cannot increase token supply");
        token2.batchMint(recipients, uris);

        uint256 Abal = token2.balanceOf(alice);
        assertEq(Abal, 0);

        uint256 Bbal = token2.balanceOf(bob);
        assertEq(Bbal, 0);

        uint256 Cbal = token2.balanceOf(charlie);
        assertEq(Cbal, 0);

        vm.stopPrank();
    }

    /**
     * @dev URI should be updated
     */
    function testUpgradableURI() public {
        vm.startPrank(alice);

        address[] memory recipients = new address[](3);
        string[] memory uris = new string[](3);

        recipients[0] = alice;
        recipients[1] = bob;
        recipients[2] = charlie;

        uris[0] = "x";
        uris[1] = "y";
        uris[2] = "z";

        token1.batchMint(recipients, uris);
        assertEq(token1.tokenURI(2), uris[1]);

        token1.updateURI(2, "k");
        assertEq(token1.tokenURI(2), "k");

        vm.stopPrank();
    }

    /**
     * @dev URI should not be updated for non-existent token
     */
    function testUpgradableURINonexistent() public {
        vm.startPrank(alice);

        address[] memory recipients = new address[](3);
        string[] memory uris = new string[](3);

        recipients[0] = alice;
        recipients[1] = bob;
        recipients[2] = charlie;

        uris[0] = "x";
        uris[1] = "y";
        uris[2] = "z";

        token1.batchMint(recipients, uris);

        vm.expectRevert("URI set of nonexistent token");
        token1.updateURI(4, "k");

        vm.stopPrank();
    }

    /**
     * @dev URI should not be updated after toggle disable
     */
    function testUpgradableURIImmutable() public {
        vm.startPrank(alice);

        address[] memory recipients = new address[](3);
        string[] memory uris = new string[](3);

        recipients[0] = alice;
        recipients[1] = bob;
        recipients[2] = charlie;

        uris[0] = "x";
        uris[1] = "y";
        uris[2] = "z";

        token1.batchMint(recipients, uris);
        assertEq(token1.tokenURI(2), uris[1]);

        token1.setUriImmutable();

        vm.expectRevert("URIs are immutable");
        token1.updateURI(2, "k");

        assertEq(token1.getTokenId(), uris.length);

        vm.stopPrank();
    }

    function createInitData() public virtual {
        // erc721 init data
        data1.admin = alice;
        data1.maxSupply = 0;
        data1.name = "Futuro1";
        data1.symbol = "FTR1";

        data2.admin = bob;
        data2.maxSupply = 2;
        data2.name = "Futuro2";
        data2.symbol = "FTR2";
    }
}
