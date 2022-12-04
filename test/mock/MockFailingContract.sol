// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MockFailingContract {
    function fail() public pure {
        revert("MockFailingContract: fail");
    }
}
