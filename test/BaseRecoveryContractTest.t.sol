// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";
import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {BaseRecoveryContract} from "../src/BaseRecoveryContract.sol";
import {MockFailingContract} from "./mock/MockFailingContract.sol";

abstract contract BaseRecoveryContractTest is Test, GasSnapshot {
    error Unauthorized();
    error CallFailed();

    function testOnlyOwner() public {
        address recipient = address(1);
        vm.expectRevert(Unauthorized.selector);
        recovery().call(recipient, 1 ether, hex"");
    }

    function testCallFailed() public {
        address recipient = address(new MockFailingContract());
        vm.prank(owner());
        vm.expectRevert(CallFailed.selector);
        recovery().call(recipient, 0, abi.encodePacked(MockFailingContract.fail.selector));
    }

    function testRecoverEtherInsufficientBalance() public {
        address recipient = address(1);
        vm.prank(owner());
        vm.expectRevert(CallFailed.selector);
        recovery().call(recipient, 1 ether, hex"");
    }

    function testRecoverEther() public {
        address recipient = address(1);
        uint256 balanceBefore = recipient.balance;
        vm.prank(owner());
        vm.deal(address(recovery()), 1 ether);
        snap(string.concat("RecoverEther"));
        recovery().call(recipient, 1 ether, hex"");
        snapEnd();
        assertEq(recipient.balance, balanceBefore + 1 ether);
    }

    function testRecoverERC20InsufficientBalance() public {
        ERC20 token = new ERC20("test", "TEST");
        address recipient = address(1);
        vm.prank(owner());
        vm.expectRevert(CallFailed.selector);
        snap("RecoverERC20");
        recovery().call(address(token), 0, abi.encodeWithSelector(token.transfer.selector, recipient, 1 ether));
        snapEnd();
    }

    function testRecoverERC20() public {
        ERC20 token = new ERC20("test", "TEST");
        address recipient = address(1);
        deal(address(token), address(recovery()), 1 ether);
        vm.prank(owner());
        recovery().call(address(token), 0, abi.encodeWithSelector(token.transfer.selector, recipient, 1 ether));
        assertEq(token.balanceOf(recipient), 1 ether);
    }

    function snap(string memory key) internal {
        snapStart(string.concat(snapshotName(), key));
    }

    function snapshotName() internal virtual returns (string memory);
    function owner() internal virtual returns (address);
    function recovery() internal virtual returns (BaseRecoveryContract);
}
