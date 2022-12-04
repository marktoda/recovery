// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ClonesWithImmutableArgs} from "clones-with-immutable-args/ClonesWithImmutableArgs.sol";
import {BaseRecoveryContract} from "./BaseRecoveryContract.sol";

/// @notice A Contract to recover funds sent to a contract that does not yet exist.
/// @dev useful for example if funds are accidentally sent to the wrong chain
/// @dev optimized for deployment cost
contract RecoveryContract is BaseRecoveryContract {
    address internal immutable internalOwner;

    constructor(address _owner) {
        internalOwner = _owner;
    }

    /// @notice deploys a sub-recovery address
    /// @dev useful in the case that the contract needing recovery was deployed by a factory
    /// @dev inherits the owner of this recovery contract
    function deployChildren(uint256 num) external onlyOwner {
        for (uint256 i = 0; i < num; i++) {
            bytes memory data = abi.encodePacked(internalOwner);
            ClonesWithImmutableArgs.clone(address(this), data);
        }
    }

    function owner() internal view override returns (address) {
        return internalOwner;
    }

    receive() external payable {}
    fallback() external payable {}
}
