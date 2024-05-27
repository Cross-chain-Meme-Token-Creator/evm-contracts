// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {BytesLib} from "solidity-bytes-utils/contracts/BytesLib.sol";
import {WormholeState} from "./wormhole/WormholeState.sol";
import {WormholeMessages} from "./wormhole/WormholeMessages.sol";
import {IWormhole} from "./wormhole/IWormhole.sol";
import {ITokenBridge} from "./wormhole/ITokenBridge.sol";
import {WormholeGovernance} from "./wormhole/WormholeGovernance.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Token is ERC20, WormholeMessages, WormholeGovernance, ReentrancyGuard {
    using BytesLib for bytes;

    address public factoryAddr;

    uint8 private _decimals;
    string public description;
    string public iconUrl;

    constructor(
        address _factoryAddr,
        address _wormholeAddr,
        address _tokenBridgeAddr,
        uint16 _chainId,
        uint8 _wormholeFinality,
        uint8 __decimals,
        string memory name,
        string memory symbol,
        string memory _description,
        string memory _iconUrl
    ) ERC20(name, symbol) {
        factoryAddr = _factoryAddr;
        state.wormholeAddr = _wormholeAddr;
        state.tokenBridgeAddr = _tokenBridgeAddr;
        state.chainId = _chainId;
        state.wormholeFinality = _wormholeFinality;

        _decimals = __decimals;
        description = _description;
        iconUrl = _iconUrl;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function sendTokensWithPayload(
        address tokenAddr,
        uint256 amount,
        uint16 targetChain,
        uint32 batchId,
        bytes32 targetRecipient
    ) public payable nonReentrant returns (uint64 messageSequence) {
        // sanity check function arguments
        require(tokenAddr != address(0), "token cannot be address(0)");
        require(amount > 0, "amount must be greater than 0");
        require(
            targetRecipient != bytes32(0),
            "targetRecipient cannot be bytes32(0)"
        );

        /**
         * Compute the normalized amount to verify that it's nonzero.
         * The token bridge peforms the same operation before encoding
         * the amount in the `TransferWithPayload` message.
         */
        require(
            normalizeAmount(amount, ERC20(tokenAddr).decimals()) > 0,
            "normalized amount must be > 0"
        );

        // Cache the target contract address and verify that there
        // is a registered emitter for the specified targetChain.
        bytes32 targetContract = state.registeredEmitters[targetChain];
        require(targetContract != bytes32(0), "emitter not registered");

        // Cache Wormhole fee value, and confirm that the caller has sent
        // enough value to pay for the Wormhole message fee.
        IWormhole wormhole = IWormhole(state.wormholeAddr);
        uint256 wormholeFee = wormhole.messageFee();
        require(msg.value == wormholeFee, "insufficient value");

        // transfer tokens from user to the this contract
        uint256 amountReceived = custodyTokens(tokenAddr, amount);

        /**
         * Encode instructions (HelloTokenMessage) to send with the token transfer.
         * The `targetRecipient` address is in bytes32 format (zero-left-padded) to
         * support non-evm smart contracts that have addresses that are longer
         * than 20 bytes.
         */
        bytes memory messagePayload = encodePayload(
            Message({payloadID: 1, targetRecipient: targetRecipient})
        );

        // approve the token bridge to spend the specified tokens
        IERC20(tokenAddr).approve(state.tokenBridgeAddr, amountReceived);

        /**
         * Call `transferTokensWithPayload`method on the token bridge and pay
         * the Wormhole network fee. The token bridge will emit a Wormhole
         * message with an encoded `TransferWithPayload` struct (see the
         * ITokenBridge.sol interface file in this repo).
         */
        // cache TokenBridge instance
        ITokenBridge tokenBridge = ITokenBridge(state.tokenBridgeAddr);

        messageSequence = tokenBridge.transferTokensWithPayload{value: wormholeFee}(
            tokenAddr,
            amountReceived,
            targetChain,
            targetContract,
            batchId,
            messagePayload
        );
    }

     function custodyTokens(
        address token,
        uint256 amount
    ) internal returns (uint256) {
        // query own token balance before transfer
        uint256 balanceBefore = getBalance(token);

        // deposit tokens
        SafeERC20.safeTransferFrom(
            IERC20(token),
            msg.sender,
            address(this),
            amount
        );

        // return the balance difference
        return getBalance(token) - balanceBefore;
    }

    function normalizeAmount(
        uint256 amount,
        uint8 __decimals
    ) internal pure returns (uint256) {
        if (__decimals > 8) {
            amount /= 10 ** (__decimals - 8);
        }
        return amount;
    }

     function getBalance(address token) internal view returns (uint256 balance) {
        // fetch the specified token balance for this contract
        (, bytes memory queriedBalance) =
            token.staticcall(
                abi.encodeWithSelector(IERC20.balanceOf.selector, address(this))
            );
        balance = abi.decode(queriedBalance, (uint256));
    }
}
