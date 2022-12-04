# Recovery Contract

You have a contract on chain X, but you accidentally sent funds to the contract's address on chain Y. But it doesn't exist on chain Y (yet)!

You could re-deploy the contract on chain Y to recover the funds, but that could be cost-prohibitive (i.e. if you've done this many many times). Even worse, if your contract on chain X deployed child contracts, we would need to grind out all of those deployments on chain Y to get to the correct contract nonce.

This tiny recovery contract is intended as a simple, cost-effective way to recover funds that were lost in this way. It optimizes for deployment cost to be as cheap as possible to deploy.


## API

**deploy(owner)**

Deploys a new recovery contract. Owner is the address that will be able to recover funds.

**call(to, value, data)**

Call an arbitrary address with given data and ETH value. Main function used for recovery

**deployChildren(num)**

Deploys the given number of children contracts. These have the same API as the parent contract, but can't deploy children of their own.
