# Token Factory

## About This Project
#### Token Factory to deploy customizable ERC-20 / 721 / 1155s w/ CREATE2
Customizable options for tokens:

ERC20
- name, symbol
- limited / unlimited token supply

ERC721
- name, symbol
- limited / unlimited token supply
- token specific URI

ERC1155
- name, symbol
- token-type specific limited / unlimited token supply
- token-type specific URI

## Install Foundry/Forge
#### Foundry Book: https://book.getfoundry.sh/getting-started/installation

After Foundry is installed and this repo has been cloned, run the following commands:

`forge build`

`forge test`

## How To Use The Token Factory

Run the deploy factory script in the script folder to any EVM network `DeployFactory.s.sol`

`forge script script/DeployFactory.s.sol:DeployFactoryScript --rpc-url $RPC_URL_API --private-key $PRIVATE_KEY --broadcast -vvvv`

This script uses the CREATE2 opcode, so it will have the same contract address on any network, dependent on the `SALT`

To deploy token contracts, call `deployERC20`, `deployERC721`, or `deployERC1155` on the factory. These functions also use CREATE2 opcode, so they will deploy to the same contract address on each EVM network.

The params for each token deployment function are found in the `IInitData` interface, as follows:
```
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

    struct ERC1155Data {
        address admin;
        string name;
        string symbol;
        string uri;
    }
    
```
## Contract Verification

#### Forge Verify-Contract: https://book.getfoundry.sh/reference/forge/forge-verify-contract

Factory Verification

`forge verify-contract --chain <ID> --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" --constructor-args $(cast abi-encode "constructor(address)" <EOA_ADDRESS>) <CONTRACT_ADDRESS> TokenFactory $BLOCK_EXPLORER_KEY`

Token Verification

`forge verify-contract --chain <ID> --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" <CONTRACT_ADDRESS> KERC20 $BLOCK_EXPLORER_KEY`

`forge verify-contract --chain <ID> --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" <CONTRACT_ADDRESS> KERC721 $BLOCK_EXPLORER_KEY`

`forge verify-contract --chain <ID> --flatten --watch --compiler-version "v0.8.11+commit.d7f03943" <CONTRACT_ADDRESS> KERC1155 $BLOCK_EXPLORER_KEY`

## License

MIT License

Copyright (c) 2023 Hunter King

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
