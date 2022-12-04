// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {RecoveryContract} from "../src/RecoveryContract.sol";
import {RecoveryContractFactory} from "../src/RecoveryContractFactory.sol";
import {BaseRecoveryContractTest} from "./BaseRecoveryContract.t.sol";

contract RecoveryContractFactoryTest is BaseRecoveryContractTest {
    function setUp() public override {
        owner = vm.addr(1234);
        RecoveryContractFactory factory = new RecoveryContractFactory(owner);
        vm.prank(owner);
        recovery = RecoveryContract(payable(factory.deploy()));
        snapPrefix = "Factory";
    }

    function testDeployGas() public {
        RecoveryContractFactory factory = new RecoveryContractFactory(owner);
        snap("Deploy");
        factory.deploy();
        snapEnd();
    }
}
