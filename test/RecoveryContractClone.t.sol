// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Clones} from "openzeppelin-contracts/proxy/Clones.sol";
import {RecoveryContract} from "../src/RecoveryContract.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

/// @notice tests deploying clone instances directly w/o factory
contract RecoveryContractCloneTest is BaseRecoveryContractTest {
    address private implementation;

    function setUp() public override {
        owner = vm.addr(1234);
        implementation = address(new RecoveryContract(owner));
        recovery = RecoveryContract(payable(Clones.clone(implementation)));
        snapPrefix = "Clone";
    }

    function testDeployGas() public {
        snap("Deploy");
        Clones.clone(implementation);
        snapEnd();
    }
}
