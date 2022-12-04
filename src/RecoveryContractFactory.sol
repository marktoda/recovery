// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Clones} from "openzeppelin-contracts/proxy/Clones.sol";
import {RecoveryContract} from "./RecoveryContract.sol";

contract RecoveryContractFactory {
    address public immutable implementation;

    constructor(address owner) {
        implementation = address(new RecoveryContract(owner));
    }

    function deploy() external returns (address) {
        // note that the clone does not need an initializer
        // because owner is immutable, it is inherited from implementation upon delegatecall
        // note also that clones can themselves deploy children,
        // as clones to calls are delegatecall-chained
        // this results in slightly higher runtime gas costs for clones-of-clones and
        // each subsequent layer, but I expect it to rarely be useful beyond 1 or 2 layers.
        return Clones.clone(implementation);
    }
}
