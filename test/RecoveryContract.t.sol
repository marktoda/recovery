// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ClonesWithImmutableArgs} from "clones-with-immutable-args/ClonesWithImmutableArgs.sol";
import {CloneableRecoveryContract} from "../src/CloneableRecoveryContract.sol";
import {RecoveryContract} from "../src/RecoveryContract.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

contract RecoveryContractTest is BaseRecoveryContractTest {
    CloneableRecoveryContract internal cloneable;

    function setUp() public override {
        owner = vm.addr(1234);
        cloneable = new CloneableRecoveryContract();
        recovery = new RecoveryContract(owner, address(cloneable));
        snapPrefix = "Concrete";
    }

    function testDeployGas() public {
        snap("Deploy");
        recovery = new RecoveryContract(owner, address(cloneable));
        snapEnd();
    }
}
