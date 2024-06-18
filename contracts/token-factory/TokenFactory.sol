// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;
import {Token} from "../token/Token.sol";

import {TokenFactoryState} from "./abstracts/TokenFactoryState.sol";
import {ITokenFactory} from "./interfaces/ITokenFactory.sol";
import {ITokenFactoryWriter} from "./interfaces/ITokenFactoryWriter.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";

contract TokenFactory is TokenFactoryState, Multicall, ITokenFactory {
    function createToken(
        ITokenFactoryWriter.CreateTokenParams calldata params
    ) external override returns (address tokenAddr) {
        tokenAddr = address(
            new Token(
                params.name,
                params.symbol,
                params.decimals,
                params.totalSupply,
                msg.sender
            )
        );
        getCreatorAddr[tokenAddr] = msg.sender;

        emit TokenCreated(tokenAddr, params.name, params.symbol, msg.sender);
    }
}