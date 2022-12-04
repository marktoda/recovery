// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Clones} from "openzeppelin-contracts/proxy/Clones.sol";

struct Call {
    address to;
    uint256 value;
    bytes data;
}

/// @notice A Contract to recover funds sent to a contract that does not yet exist.
/// @dev useful for example if funds are accidentally sent to the wrong chain
/// @dev optimized for deployment cost
/// @dev This contract can be safely cloned, inheriting the owner of the cloned contract
contract RecoveryContract {
    error Unauthorized();
    error CallFailed();

    address immutable private owner;

    modifier onlyOwner() virtual {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    /// @notice calls an address with arbitrary data and value specified by the owner
    function call(address to, uint256 value, bytes memory data) external onlyOwner {
        (bool success,) = to.call{value: value}(data);
        if (!success) revert CallFailed();
    }

    /// @notice calls an address with arbitrary data and value specified by the owner
    function call(Call[] memory calls) external onlyOwner {
        for (uint256 i = 0; i < calls.length; i++) {
            Call memory callData = calls[i];
            (bool success,) = callData.to.call{value: callData.value}(callData.data);
            if (!success) revert CallFailed();
        }
    }

    /// @notice deploys a sub-recovery address
    /// @dev useful in the case that the contract needing recovery was deployed by a factory
    /// @dev inherits the owner of this recovery contract
    function deployChildren(uint256 num) external onlyOwner {
        for (uint256 i = 0; i < num; i++) {
            // note that the clone does not need an initializer
            // because owner is immutable, it is inherited upon delegatecall
            // note also that clones can themselves deploy children,
            // as clones to calls are delegatecall-chained
            // this results in slightly higher runtime gas costs for clones-of-clones and
            // each subsequent layer, but I expect it to rarely be useful beyond 1 or 2 layers.
            Clones.clone(address(this));
        }
    }

    receive() external payable {}
    fallback() external payable {}
}
