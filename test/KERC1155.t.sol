// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "test/TestHelper.sol";
import {KERC1155} from "src/tokens/KERC1155.sol";

// forge test --match-contract KERC1155Test -vv

contract KERC1155Test is TestHelper {
    ERC1155Data public data1;

    KERC1155 public token1;

    function setUp() public override {
        factory = new TokenFactory(admin);
        createInitData();

        token1 = KERC1155(factory.deployERC1155(SALT1, data1));
    }

    /**
     * @dev Only admin should be able to createAndmint
     */
    function testCreateAndMinPermissions() public {
        vm.startPrank(alice);

        token1.createAndMint(bob, 100, 0);

        uint256 Abal = token1.balanceOf(alice, 1);
        assertEq(Abal, 0);

        uint256 Bbal = token1.balanceOf(bob, 1);
        assertEq(Bbal, 100);

        vm.stopPrank();
    }

    /**
     * @dev Non-admin should not be able to createAndmint
     */
    function testCreateAndMintPermissionsFail() public {
        vm.startPrank(bob);

        vm.expectRevert("Ownable: caller is not the owner");
        token1.createAndMint(alice, 100, 0);

        uint256 Abal = token1.balanceOf(alice, 1);
        assertEq(Abal, 0);

        uint256 Bbal = token1.balanceOf(bob, 1);
        assertEq(Bbal, 0);

        vm.stopPrank();
    }

    /**
     * @dev Only admin should be able to mint
     */
    function testMinPermissions() public {
        vm.startPrank(alice);

        token1.createAndMint(bob, 100, 0);
        token1.mint(bob, 1, 50);

        uint256 Bbal = token1.balanceOf(bob, 1);
        assertEq(Bbal, 150);

        vm.stopPrank();
    }

    /**
     * @dev Non-admin should not be able to mint
     */
    function testMintPermissionsFail() public {
        vm.startPrank(alice);

        token1.createAndMint(bob, 100, 0);

        vm.stopPrank();

        vm.startPrank(bob);

        vm.expectRevert("Ownable: caller is not the owner");
        token1.mint(bob, 1, 50);

        uint256 Bbal = token1.balanceOf(bob, 1);
        assertEq(Bbal, 100);

        vm.stopPrank();
    }

    /**
     * @dev Should mint up to finite limit
     */
    function testMinFinitePass() public {
        vm.startPrank(alice);

        token1.createAndMint(bob, 100, 150);
        token1.mint(bob, 1, 50);

        uint256 Bbal = token1.balanceOf(bob, 1);
        assertEq(Bbal, 150);

        vm.stopPrank();
    }

    /**
     * @dev Should not mint over finite limit
     */
    function testMintFiniteFail() public {
        vm.startPrank(alice);

        token1.createAndMint(bob, 100, 150);

        vm.expectRevert("Cannot increase token supply");
        token1.mint(bob, 1, 100);

        uint256 Bbal = token1.balanceOf(bob, 1);
        assertEq(Bbal, 100);

        vm.stopPrank();
    }

    /**
     * @dev Should not mint non-existent id
     */
    function testMintNonexistentFail() public {
        vm.startPrank(alice);

        token1.createAndMint(bob, 100, 0);

        vm.expectRevert("Token id is nonexistent");
        token1.mint(bob, 2, 100);

        vm.stopPrank();
    }

    /**
     * @dev Should batch mint appropriate amounts by id
     */
    function testBatchMint() public {
        vm.startPrank(alice);

        token1.createAndMint(alice, 20, 100);
        token1.createAndMint(alice, 200, 1000);
        token1.createAndMint(alice, 1, 3);

        address[] memory recipients = new address[](3);
        uint256[] memory tokenIds = new uint256[](3);
        uint256[] memory amounts = new uint256[](3);

        recipients[0] = bob;
        recipients[1] = bob;
        recipients[2] = charlie;

        tokenIds[0] = 1;
        tokenIds[1] = 2;
        tokenIds[2] = 3;

        amounts[0] = 80;
        amounts[1] = 800;
        amounts[2] = 2;

        token1.batchMint(recipients, tokenIds, amounts);

        uint256 Abal1 = token1.balanceOf(alice, 1);
        uint256 Abal2 = token1.balanceOf(alice, 2);
        uint256 Abal3 = token1.balanceOf(alice, 3);
        uint256 Bbal1 = token1.balanceOf(bob, 1);
        uint256 Bbal2 = token1.balanceOf(bob, 2);
        uint256 Cbal3 = token1.balanceOf(charlie, 3);

        assertEq(Abal1, 20);
        assertEq(Abal2, 200);
        assertEq(Abal3, 1);
        assertEq(Bbal1, 80);
        assertEq(Bbal2, 800);
        assertEq(Cbal3, 2);

        assertEq(token1.getTokenId(), 3);

        vm.stopPrank();
    }

    /**
     * @dev URI should be updated
     */
    function testUpgradableURI() public {
        vm.startPrank(alice);

        assertEq(token1.uri(1), "abc");

        token1.updateURI("xyz");
        assertEq(token1.uri(1), "xyz");

        vm.stopPrank();
    }

    /**
     * @dev URI should not be updated
     */
    function testUpgradableURIFail() public {
        vm.startPrank(alice);

        assertEq(token1.uri(1), "abc");

        token1.setUriImmutable();

        vm.expectRevert("URIs are immutable");
        token1.updateURI("xyz");
        assertEq(token1.uri(1), "abc");

        vm.stopPrank();
    }

    function createInitData() public virtual {
        // erc1155 init data
        data1.admin = alice;
        data1.name = "Futuro1";
        data1.symbol = "FTR1";
        data1.uri = "abc";
    }
}
