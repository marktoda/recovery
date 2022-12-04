// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {ClonesWithImmutableArgs} from "clones-with-immutable-args/ClonesWithImmutableArgs.sol";
import {CloneableRecoveryContract} from "../src/CloneableRecoveryContract.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

contract CloneableRecoveryContractTest is BaseRecoveryContractTest {
    function setUp() public override {
        owner = vm.addr(1234);
        impl = address(new CloneableRecoveryContract());
        bytes memory data = abi.encodePacked(owner);
        recovery = CloneableRecoveryContract(payable(ClonesWithImmutableArgs.clone(impl, data)));
        snapPrefix = "";
    }

    function testDeployGas() public {
        bytes memory data = abi.encodePacked(owner);
        snap("Deploy");
        ClonesWithImmutableArgs.clone(impl, data);
        snapEnd();
    }
}
