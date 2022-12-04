// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";
import {BaseRecoveryContract} from "../src/BaseRecoveryContract.sol";
import {RecoveryContract} from "../src/RecoveryContract.sol";
import {RecoveryContractClone} from "../src/RecoveryContractClone.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContractTest.t.sol";

contract RecoveryContractCloneTest is BaseRecoveryContractTest {
    address private _owner;
    RecoveryContract private _parent;
    RecoveryContractClone private _recovery;

    function setUp() public {
        _owner = address(1234);
        _parent = new RecoveryContract(_owner);
        vm.prank(_owner);
        _recovery = RecoveryContractClone(_parent.deployChild());
    }

    function testDeployGas() public {
        vm.prank(_owner);
        snap("Deploy");
        _parent.deployChild();
        snapEnd();
    }

    function snapshotName() internal pure override returns (string memory) {
        return "RecoveryContractClone";
    }

    function owner() internal view override returns (address) {
        return _owner;
    }

    function recovery() internal view override returns (BaseRecoveryContract) {
        return _recovery;
    }
}
