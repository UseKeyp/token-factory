// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC1155 {
    function balanceOf(address account, uint256 id) external view returns (uint256);
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address account, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event URI(string value, uint256 indexed id);
}

contract ERC1155TokenFactory {
    mapping(address => address[]) public tokens;

    function createToken(string memory _uri) public returns (address) {
        ERC1155Token newToken = new ERC1155Token(_uri, msg.sender);
        tokens[msg.sender].push(address(newToken));
        return address(newToken);
    }

    function getTokenCount(address _owner) public view returns (uint256) {
        return tokens[_owner].length;
    }
}

contract ERC1155Token is IERC1155 {
    string public uri;
    address public owner;

    mapping(address => mapping(uint256 => uint256)) public balances;
    mapping(address => mapping(address => bool)) public operators;

    constructor(string memory _uri, address _owner) {
        uri = _uri;
        owner = _owner;
    }

    function balanceOf(address _account, uint256 _id) public view override returns (uint256) {
        return balances[_account][_id];
    }

    function balanceOfBatch(address[] calldata _accounts, uint256[] calldata _ids) public view override returns (uint256[] memory) {
        require(_accounts.length == _ids.length, "ERC1155: accounts and ids length mismatch");
        uint256[] memory batchBalances = new uint256[](_accounts.length);
        for (uint256 i = 0; i < _accounts.length; i++) {
            batchBalances[i] = balances[_accounts[i]][_ids[i]];
        }
        return batchBalances;
    }

    function setApprovalForAll(address _operator, bool _approved) public override {
        operators[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _account, address _operator) public view override returns (bool) {
        return operators[_account][_operator];
    }

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) public override {
        require(_to != address(0), "ERC1155: transfer to the zero address");
        require(_from == msg.sender || isApprovedForAll(_from, msg.sender), "ERC1155: caller is not owner nor approved");
        balances[_from][_id] -= _amount;
        balances[_to][_id] += _amount;
        emit TransferSingle(msg.sender, _from, _to, _id, _amount);
       
