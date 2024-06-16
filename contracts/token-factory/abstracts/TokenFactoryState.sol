// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;

import {ITokenFactoryState} from "../interfaces/ITokenFactoryState.sol";
abstract contract TokenFactoryState is ITokenFactoryState {
    mapping(address => address) public override getCreatorAddr; 
}