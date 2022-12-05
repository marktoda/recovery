# Recovery Contract

This tiny recovery contract is intended as a simple, cost-optimized way to recover funds that were accidentally sent to a contract on the wrong chain.

The deployer of the contract can deploy recovery contracts to the correct address and recover funds using admin privileges. Support for multiple contracts and contracts created from factories is also supported through efficient self-cloning.

## Usage

**Standard Usage**

Deploy RecoveryContract using the correct nonce and sender address. It will be able to recover funds and deploy child contracts cheaply.
Note if you have more than one contract to recover, this is NOT the most gas-optimized method

**Clone Usage**
Deploy a RecoveryContract using the _any_ nonce and sender address. Generate EIP-1167 proxy bytecode _offchain_ targeting the deployed contract. Deploy this proxy bytecode using the correct nonce and sender address.
This is the most optimized method if you have multiple contracts to recover for a given owner. Integration is a bit of a pain as EIP-1167 data is generally not deployed directly from an EOA.

**Factory Usage**
RecoveryContract itself acts as a factory and can deploy child contracts using its own contract nonce. If the contract you are trying to recover was deployed with CREATE by a factory, you can use this functionality to recover its address as well.

## API

**constructor(owner)**

Deploys a new recovery contract. Owner is the address that will be able to recover funds.

**call(to, value, data)**

Call an arbitrary address with given data and ETH value. Main function used for recovery

**call(Call[] calls)**

Performs a batch of calls.

**clone(num)**

Deploys the given number of children contracts. These function the same as the parent and inherit its owner.

## Benchmarks

**Deployment**
- RecoveryContract: 342k gas
- RecoveryContract clone: 43k gas
- RecoveryContract single child: 46k gas
- RecoveryContract 100 children: 41k gas each

**Recovery**
- ETH recovery: 36k gas
- ETH recovery from child: 39k gas
- ETH recovery from child of child: 77k gas

## Notes
- Removal of the batch call function lowers deployment cost to 220k gas. But I figure this is quite a useful feature and worth the extra gas. As the contract is likely to be owned by an EOA, out-of-band batching is probably not possible.
