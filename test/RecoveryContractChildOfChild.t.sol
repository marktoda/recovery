// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {RecoveryContract} from "../src/RecoveryContract.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

contract RecoveryContractChildOfChildTest is BaseRecoveryContractTest {
    function setUp() public override {
        owner = vm.addr(1234);
        RecoveryContract parent = new RecoveryContract(owner);
        vm.prank(owner);
        parent.clone(1);
        RecoveryContract middle = RecoveryContract(payable(computeCreateAddress(address(parent), 1)));

        vm.prank(owner);
        middle.clone(1);
        recovery = RecoveryContract(payable(computeCreateAddress(address(middle), 1)));

        snapPrefix = "ChildOfChild";
    }
}
