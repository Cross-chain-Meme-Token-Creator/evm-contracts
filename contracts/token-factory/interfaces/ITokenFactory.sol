// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;

import {ITokenFactoryEvents} from "./ITokenFactoryEvents.sol";
import {ITokenFactoryState} from "./ITokenFactoryState.sol";
import {ITokenFactoryWriter} from "./ITokenFactoryWriter.sol";

interface ITokenFactory is
    ITokenFactoryEvents,
    ITokenFactoryState,
    ITokenFactoryWriter
{}
