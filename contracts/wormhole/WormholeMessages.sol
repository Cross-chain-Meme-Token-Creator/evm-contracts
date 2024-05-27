// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.26;
import {BytesLib} from "solidity-bytes-utils/contracts/BytesLib.sol";

contract WormholeMessages {
    using BytesLib for bytes;

    struct Message {
        // unique identifier for this message type
        uint8 payloadID;
        // tokenAddr and amount
        bytes32 targetRecipient;
    }

    function encodePayload(
        Message memory parsedMessage
    ) public pure returns (bytes memory encodedMessage) {
        // Convert message string to bytes so that we can use the .length attribute.
        // The length of the arbitrary messages needs to be encoded in the message
        // so that the corresponding decode function can decode the message properly.

        encodedMessage = abi.encodePacked(
            parsedMessage.payloadID,
            uint16(parsedMessage.targetRecipient.length),
            parsedMessage.targetRecipient
        );
    }

    function decodePayload(
        bytes memory encodedMessage
    ) public pure returns (Message memory parsedMessage) {
        uint256 index = 0;

        // parse payloadId
        parsedMessage.payloadID = encodedMessage.toUint8(index);
        require(parsedMessage.payloadID == 1, "invalid payloadID");
        index += 1;

        // target wallet recipient
        parsedMessage.targetRecipient = encodedMessage.toBytes32(index);
        index += 32;

        // confirm that the payload was the expected size
        require(index == encodedMessage.length, "invalid payload length");
    }
}
