// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;

interface ITokenFactoryWriter {
    struct CreateTokenParams {
        string name;
        string symbol;
        uint8 decimals;
        uint256 totalSupply;
    }

    function createToken(
        CreateTokenParams calldata params
    ) external returns (address tokenAddr);
}
