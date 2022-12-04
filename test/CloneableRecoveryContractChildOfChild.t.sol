// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ClonesWithImmutableArgs} from "clones-with-immutable-args/ClonesWithImmutableArgs.sol";
import {CloneableRecoveryContract} from "../src/CloneableRecoveryContract.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

contract CloneableRecoveryContractChildOfChildTest is BaseRecoveryContractTest {
    function setUp() public override {
        owner = vm.addr(1234);
        impl = address(new CloneableRecoveryContract());
        bytes memory data = abi.encodePacked(owner);
        CloneableRecoveryContract parent = CloneableRecoveryContract(payable(ClonesWithImmutableArgs.clone(impl, data)));

        vm.prank(owner);
        parent.deployChildren(1);
        CloneableRecoveryContract middle = CloneableRecoveryContract(payable(computeCreateAddress(address(parent), 1)));

        vm.prank(owner);
        middle.deployChildren(1);
        recovery = CloneableRecoveryContract(payable(computeCreateAddress(address(middle), 1)));

        snapPrefix = "ChildOfChild";
    }
}
