// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "test/TestHelper.sol";
import {KERC20} from "src/tokens/KERC20.sol";

// forge test --match-contract KERC20Test -vvvv

contract KERC20Test is TestHelper {
    ERC20Data public data1;
    ERC20Data public data2;

    KERC20 public token1;
    KERC20 public token2;

    function setUp() public override {
        factory = new TokenFactory(admin);
        createInitData();

        token1 = KERC20(factory.deployERC20(SALT1, data1));
        token2 = KERC20(factory.deployERC20(SALT2, data2));
    }

    /**
     * @dev Initialize mint to recipient
     */
    function testInitialMintRecipient() public {
        uint256 Abal = token1.balanceOf(alice);
        assertEq(Abal, 0);

        uint256 Cbal = token1.balanceOf(charlie);
        assertEq(Cbal, 100 * 1e18);
    }

    /**
     * @dev Only admin should be able to mint
     */
    function testMintPermissions() public {
        vm.startPrank(alice);

        token1.mint(bob, 50 * 1e18);

        uint256 Abal = token1.balanceOf(alice);
        assertEq(Abal, 0);

        uint256 Bbal = token1.balanceOf(bob);
        assertEq(Bbal, 50 * 1e18);

        vm.stopPrank();
    }

    /**
     * @dev Non-admin should not be able to mint
     */
    function testMintPermissionsFail() public {
        vm.startPrank(bob);

        vm.expectRevert("Ownable: caller is not the owner");
        token1.mint(alice, 50 * 1e18);

        uint256 Abal = token1.balanceOf(alice);
        assertEq(Abal, 0);

        uint256 Bbal = token1.balanceOf(bob);
        assertEq(Bbal, 0);

        vm.stopPrank();
    }

    /**
     * @dev Finite token supply should not allow mint
     */
    function testFiniteMintFail() public {
        uint256 Cbal = token2.balanceOf(charlie);
        assertEq(Cbal, 200 * 1e18);

        vm.startPrank(alice);

        vm.expectRevert("Cannot increase token supply");
        token2.mint(alice, 50 * 1e18);

        uint256 Abal = token2.balanceOf(alice);
        assertEq(Abal, 0);

        vm.stopPrank();
    }

    function createInitData() public virtual {
        // erc20 init data
        data1.admin = alice;
        data1.recipient = charlie;
        data1.initSupply = 100 * 1e18;
        data1.name = "Futuro1";
        data1.symbol = "FTR1";
        data1.finiteSupply = false;

        data2.admin = alice;
        data2.recipient = charlie;
        data2.initSupply = 200 * 1e18;
        data2.name = "Futuro2";
        data2.symbol = "FTR2";
        data2.finiteSupply = true;
    }
}
