# Recovery Contract

You have a contract on chain X, but you accidentally sent funds to the contract's address on chain Y. But it doesn't exist on chain Y!

You could re-deploy the contract on chain Y to recover the funds, but that could be cost-prohibitive (i.e. if you've done this many many times). Even worse, if your contract on chain X deployed child contracts, we would need to grind out all of those deployments on chain Y to get to the correct contract nonce.

This tiny recovery contract is intended as a simple, cost-optimized way to recover funds that were lost in this way.

## Usage

**Standard Usage**

Deploy RecoveryContract using the correct nonce and sender address. It will be able to recover funds and deploy child contracts cheaply.
Note if you have more than one contract to recover, this is NOT the most gas-optimized method

**Clone Usage**
Deploy a RecoveryContract using the _any_ nonce and sender address. Generate EIP-1167 proxy bytecode _offchain_ targeting the deployed contract. Deploy this proxy bytecode using the correct nonce and sender address.
This is the most optimized method if you have multiple contracts to recover for a given owner. Integration is a bit of a pain as EIP-1167 data is generally not deployed directly from an EOA.

## API

**constructor(owner)**

Deploys a new recovery contract. Owner is the address that will be able to recover funds.

**call(to, value, data)**

Call an arbitrary address with given data and ETH value. Main function used for recovery

**call(Call[] calls)**

Performs a batch of calls.

**deployChildren(num)**

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
