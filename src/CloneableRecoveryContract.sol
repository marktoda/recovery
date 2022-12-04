// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ClonesWithImmutableArgs} from "clones-with-immutable-args/ClonesWithImmutableArgs.sol";
import {Clone} from "clones-with-immutable-args/Clone.sol";
import {BaseRecoveryContract} from "./BaseRecoveryContract.sol";

struct Call {
    address to;
    uint256 value;
    bytes data;
}

/// @notice A Contract to recover funds sent to a contract that does not yet exist.
/// @dev useful for example if funds are accidentally sent to the wrong chain
/// @dev optimized for deployment cost
/// @dev This contract can be safely cloned, inheriting the owner of the cloned contract
contract CloneableRecoveryContract is BaseRecoveryContract, Clone {
    function owner() internal override pure returns (address) {
        // note that the clone does not need an initializer
        // because owner is immutable, it is inherited upon delegatecall
        return _getArgAddress(0);
    }

    function childImplementation() internal override view returns (address) {
        // note that clones can themselves deploy children,
        // as clones to calls are delegatecall-chained
        // this results in slightly higher runtime gas costs for clones-of-clones and
        // each subsequent layer, but I expect it to rarely be useful beyond 1 or 2 layers.
        return address(this);
    }
}
