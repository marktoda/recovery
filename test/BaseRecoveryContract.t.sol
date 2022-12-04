// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {Call, RecoveryContract} from "../src/RecoveryContract.sol";
import {MockFailingContract} from "./mock/MockFailingContract.sol";

abstract contract BaseRecoveryContractTest is Test, GasSnapshot {
    error Unauthorized();
    error CallFailed();

    address internal owner;
    RecoveryContract internal recovery;
    string internal snapPrefix = "";

    function setUp() public virtual;

    function testOnlyOwnerCallSingle() public {
        address recipient = address(1);
        vm.expectRevert(Unauthorized.selector);
        recovery.call(recipient, 1 ether, hex"");
    }

    function testOnlyOwnerCallBatch() public {
        address recipient = address(1);
        Call[] memory calls = new Call[](1);
        calls[0] = Call(recipient, 1 ether, hex"");
        vm.expectRevert(Unauthorized.selector);
        recovery.call(calls);
    }

    function testDeployChild() public {
        snap("DeployChildren");
        recovery.clone(1);
        snapEnd();
    }

    function testDeploy10Children() public {
        snap("Deploy10Children");
        recovery.clone(10);
        snapEnd();
    }

    function testDeploy100Chidlren() public {
        snap("Deploy100Children");
        recovery.clone(100);
        snapEnd();
    }

    function testCallFailed() public {
        address recipient = address(new MockFailingContract());
        vm.prank(owner);
        vm.expectRevert(CallFailed.selector);
        recovery.call(recipient, 0, abi.encodePacked(MockFailingContract.fail.selector));
    }

    function testCanReceiveEther() public {
        address sender = address(5);
        vm.deal(sender, 1 ether);
        vm.prank(sender);
        (bool success,) = address(recovery).call{value: 1 ether}(hex"");
        assertTrue(success);
        assertEq(address(recovery).balance, 1 ether);
    }

    function testCanReceiveEtherWithData() public {
        address sender = address(5);
        vm.deal(sender, 1 ether);
        vm.prank(sender);
        (bool success,) = address(recovery).call{value: 1 ether}(hex"123412341324");
        assertTrue(success);
        assertEq(address(recovery).balance, 1 ether);
    }

    function testRecoverEtherInsufficientBalance() public {
        address recipient = address(1);
        vm.prank(owner);
        vm.expectRevert(CallFailed.selector);
        recovery.call(recipient, 1 ether, hex"");
    }

    function testRecoverEther() public {
        address recipient = address(1);
        uint256 balanceBefore = recipient.balance;
        vm.prank(owner);
        vm.deal(address(recovery), 1 ether);
        snap("RecoverEther");
        recovery.call(recipient, 1 ether, hex"");
        snapEnd();
        assertEq(recipient.balance, balanceBefore + 1 ether);
    }

    function testRecoverEtherBatch() public {
        address recipientA = address(1);
        address recipientB = address(2);
        Call[] memory calls = new Call[](2);
        calls[0] = Call(recipientA, 0.5 ether, hex"");
        calls[1] = Call(recipientB, 0.5 ether, hex"");

        vm.prank(owner);
        vm.deal(address(recovery), 1 ether);
        snap("RecoverEther");
        recovery.call(calls);
        snapEnd();
        assertEq(recipientA.balance, 0.5 ether);
        assertEq(recipientB.balance, 0.5 ether);
    }

    function testRecoverERC20InsufficientBalance() public {
        ERC20 token = new ERC20("test", "TEST");
        address recipient = address(1);
        vm.prank(owner);
        vm.expectRevert(CallFailed.selector);
        snap("RecoverERC20");
        recovery.call(address(token), 0, abi.encodeWithSelector(token.transfer.selector, recipient, 1 ether));
        snapEnd();
    }

    function testRecoverERC20() public {
        ERC20 token = new ERC20("test", "TEST");
        address recipient = address(1);
        deal(address(token), address(recovery), 1 ether);
        vm.prank(owner);
        recovery.call(address(token), 0, abi.encodeWithSelector(token.transfer.selector, recipient, 1 ether));
        assertEq(token.balanceOf(recipient), 1 ether);
    }

    function snap(string memory key) public {
        snapStart(string.concat(snapPrefix, key));
    }
}
