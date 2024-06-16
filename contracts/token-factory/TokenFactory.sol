// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;
import {Token} from "../token/Token.sol";

import { TokenFactoryState } from "./abstracts/TokenFactoryState.sol";
import { ITokenFactory } from "./interfaces/ITokenFactory.sol";

contract TokenFactory is TokenFactoryState, ITokenFactory {
    constructor() {}

    function createToken(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 totalSupply
    ) external override returns (address tokenAddr) {
        tokenAddr = address(new Token(name, symbol, decimals, totalSupply, msg.sender));
        getCreatorAddr[tokenAddr] = msg.sender;

        emit TokenCreated(tokenAddr, name, symbol, msg.sender);
    }
}
