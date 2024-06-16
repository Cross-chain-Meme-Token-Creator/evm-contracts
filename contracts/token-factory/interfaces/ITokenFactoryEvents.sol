// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;

interface ITokenFactoryEvents {
     event TokenCreated (
        address indexed tokenAddr,
        string name,
        string symbol,
        address creatorAddr
    );
}