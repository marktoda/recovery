// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @notice A Contract to recover funds sent to a contract that does not yet exist.
/// @dev useful for example if funds are accidentally sent to the wrong chain
/// @dev optimized for deployment cost
abstract contract BaseRecoveryContract {
    error Unauthorized();
    error CallFailed();

    modifier onlyOwner() virtual {
        if (msg.sender != owner()) revert Unauthorized();
        _;
    }

    /// @notice calls an address with arbitrary data and value specified by the owner
    function call(address to, uint256 value, bytes memory data) public onlyOwner {
        (bool success,) = to.call{value: value}(data);
        if (!success) revert CallFailed();
    }

    function owner() internal view virtual returns (address);
}
