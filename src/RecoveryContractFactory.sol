// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ClonesWithImmutableArgs} from "clones-with-immutable-args/ClonesWithImmutableArgs.sol";
import {CloneableRecoveryContract} from "./CloneableRecoveryContract.sol";

contract RecoveryContractFactory {
    address public immutable implementation;

    constructor() {
        implementation = address(new CloneableRecoveryContract());
    }

    function deploy() external returns (address) {
        bytes memory data = abi.encodePacked(msg.sender);
        return ClonesWithImmutableArgs.clone(implementation, data);
    }
}
