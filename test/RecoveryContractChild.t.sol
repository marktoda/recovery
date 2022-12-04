// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ClonesWithImmutableArgs} from "clones-with-immutable-args/ClonesWithImmutableArgs.sol";
import {CloneableRecoveryContract} from "../src/CloneableRecoveryContract.sol";
import {RecoveryContract} from "../src/RecoveryContract.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

contract RecoveryContractChildTest is BaseRecoveryContractTest {
    CloneableRecoveryContract internal cloneable;

    function setUp() public override {
        owner = vm.addr(1234);
        cloneable = new CloneableRecoveryContract();
        RecoveryContract parent = new RecoveryContract(owner, address(cloneable));
        vm.prank(owner);
        parent.deployChildren(1);
        recovery = CloneableRecoveryContract(payable(computeCreateAddress(address(parent), 1)));

        snapPrefix = "ConcreteChild";
    }
}
