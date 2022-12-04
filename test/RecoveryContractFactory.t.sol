// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {CloneableRecoveryContract} from "../src/CloneableRecoveryContract.sol";
import {RecoveryContractFactory} from "../src/RecoveryContractFactory.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

contract RecoveryContractFactoryTest is BaseRecoveryContractTest {
    function setUp() public override {
        RecoveryContractFactory factory = new RecoveryContractFactory();
        owner = vm.addr(1234);
        vm.prank(owner);
        recovery = CloneableRecoveryContract(payable(factory.deploy()));
        snapPrefix = "Factory";
    }

    function testDeployGas() public {
        RecoveryContractFactory factory = new RecoveryContractFactory();
        snap("Deploy");
        factory.deploy();
        snapEnd();
    }
}
