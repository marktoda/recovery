// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {RecoveryContract} from "../src/RecoveryContract.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

contract RecoveryContractTest is BaseRecoveryContractTest {
    function setUp() public override {
        owner = vm.addr(1234);
        recovery = new RecoveryContract(owner);
        snapPrefix = "";
    }

    function testDeployGas() public {
        snap("Deploy");
        recovery = new RecoveryContract(owner);
        snapEnd();
    }
}
