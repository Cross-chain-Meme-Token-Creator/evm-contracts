// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;
import {Token} from "./Token.sol";

contract TokenFactory {
    address[] tokenAddrs;

    address wormholeAddr;
    address tokenBridgeAddr;
    uint16 chainId;
    uint8 wormholeFinality;

    constructor(
        address _wormholeAddr,
        address _tokenBridgeAddr,
        uint16 _chainId,
        uint8 _wormholeFinality
    ) {
        wormholeAddr = _wormholeAddr;
        tokenBridgeAddr = _tokenBridgeAddr;
        chainId = _chainId;
        wormholeFinality = _wormholeFinality;
    }

    function createToken(
        uint8 _decimals,
        string memory name,
        string memory symbol,
        string memory description,
        string memory iconUrl
    ) public returns (address tokenAddr) {
        tokenAddr = address(
            new Token(
                address(this),
                wormholeAddr,
                tokenBridgeAddr,
                chainId,
                wormholeFinality,
                _decimals,
                name,
                symbol,
                description,
                iconUrl
            )
        );

        tokenAddrs.push(tokenAddr);
    }
}
