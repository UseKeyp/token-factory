// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20TokenFactory {
    mapping(address => address[]) public tokens;

    function createToken(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) public returns (address) {
        ERC20Token newToken = new ERC20Token(
            _name,
            _symbol,
            _decimals,
            _totalSupply,
            msg.sender
        );
        tokens[msg.sender].push(address(newToken));
        return address(newToken);
    }

    function getTokenCount(address _owner) public view returns (uint256) {
        return tokens[_owner].length;
    }
}
