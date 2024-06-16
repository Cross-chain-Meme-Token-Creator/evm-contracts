// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;

interface ITokenFactoryWriter {
    function createToken(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 totalSupply
    ) external returns (address tokenAddr);
}