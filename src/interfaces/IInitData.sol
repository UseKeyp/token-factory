// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IInitData {
    struct ERC20Data {
        address admin;
        address recipient;
        uint256 initSupply;
        string name;
        string symbol;
        bool finiteSupply;
    }

    struct ERC721Data {
        address admin;
        uint256 maxSupply;
        string name;
        string symbol;
    }

    // struct ERC1155Data {}
}
