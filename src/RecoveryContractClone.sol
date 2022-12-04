// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Clone} from "clones-with-immutable-args/Clone.sol";
import {BaseRecoveryContract} from "./BaseRecoveryContract.sol";

/// @notice A Contract to recover funds sent to a contract that does not yet exist.
/// @dev useful for example if funds are accidentally sent to the wrong chain
/// @dev optimized for deployment cost
/// @dev This contract can be used as a clone with initializer in case the contract was deployed by a factory
contract RecoveryContractClone is BaseRecoveryContract, Clone {
    function owner() internal pure override returns (address) {
        return _getArgAddress(0);
    }
}
