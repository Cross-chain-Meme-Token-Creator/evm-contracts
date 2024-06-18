// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";

contract Token is ERC20, Multicall {
    uint8 private _decimals;
    uint256 private _totalSupply;
    address public tokenFactoryAddr;

    constructor(
        string memory name,
        string memory symbol,
        uint8 __decimals,
        uint256 __totalSupply,
        address recipientAddr
    ) ERC20(name, symbol) {
        tokenFactoryAddr = msg.sender;
        _decimals = __decimals;
        _totalSupply = __totalSupply;
        _mint(recipientAddr, _totalSupply);
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    } 
}
