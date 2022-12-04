// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";
import {BaseRecoveryContract} from "../src/BaseRecoveryContract.sol";
import {RecoveryContract} from "../src/RecoveryContract.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContractTest.t.sol";

contract RecoveryContractTest is BaseRecoveryContractTest {
    address private _owner;
    RecoveryContract private _recovery;

    function setUp() public {
        _owner = address(1234);
        _recovery = new RecoveryContract(_owner);
    }

    function testDeployGas() public {
        snap("Deploy");
        new RecoveryContract(_owner);
        snapEnd();
    }

    function snapshotName() internal pure override returns (string memory) {
        return "RecoveryContract";
    }

    function owner() internal view override returns (address) {
        return _owner;
    }

    function recovery() internal view override returns (BaseRecoveryContract) {
        return _recovery;
    }
}
