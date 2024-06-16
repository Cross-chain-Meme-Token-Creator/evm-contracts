// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;

interface ITokenFactoryState {
    function getCreatorAddr(address tokenAddr) external view returns (address);
}