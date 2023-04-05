// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}

contract ERC721TokenFactory {
    mapping(address => address[]) public tokens;

    function createToken(string memory _name, string memory _symbol, string memory _uri) public returns (address) {
        ERC721Token newToken = new ERC721Token(_name, _symbol, _uri, msg.sender);
        tokens[msg.sender].push(address(newToken));
        return address(newToken);
    }

    function getTokenCount(address _owner) public view returns (uint256) {
        return tokens[_owner].length;
    }
}

contract ERC721Token is IERC721 {
    string public name;
    string public symbol;
    string public uri;
    address public owner;

    mapping(uint256 => address) public owners;
    mapping(address => uint256) public balances;
    mapping(uint256 => address) public approved;
    mapping(address => mapping(address => bool)) public operators;

    constructor(string memory _name, string memory _symbol, string memory _uri, address _owner) {
        name = _name;
        symbol = _symbol;
        uri = _uri;
        owner = _owner;
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        return balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
        require(owners[_tokenId] != address(0), "ERC721: owner query for nonexistent token");
        return owners[_tokenId];
    }

    function approve(address _to, uint256 _tokenId) public override {
        address tokenOwner = ownerOf(_tokenId);
        require(_to != tokenOwner, "ERC721: approval to current owner");
        require(msg.sender == tokenOwner || isApprovedForAll(tokenOwner, msg.sender), "ERC721: approve caller is not owner nor approved for all");
        approved[_tokenId] = _to;
        emit Approval(tokenOwner, _to, _tokenId);
    }

    function getApproved(uint256 _tokenId) public view override returns (address) {
        require(owners[_tokenId] != address(0), "ERC721: approved query for nonexistent token");
        return approved[_tokenId];
    }

    function setApprovalForAll(address _operator, bool _approved) public override {
        operators[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _
