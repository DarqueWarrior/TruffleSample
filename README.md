# Introduction

This repo shows how to implement DevOps best practices on a Web3 Truffle React application.

The pipelines are duplicated in [Azure Pipelines](https://azure.microsoft.com/en-us/services/devops/pipelines/) and [GitHub Workflows](https://docs.github.com/en/get-started/getting-started-with-git/git-workflows).

# Getting Started

The project was created using the [React Truffle Box](https://trufflesuite.com/boxes/react/)

While building the pipelines I encountered several situations that would force the user into DevOps anti-patterns. For example, when a contract is deployed to the blockchain the address is returned and required to communicate with the contract. By default the address of a deployed contract is written to the Network section of the contract JSON file created during compilation of the contract code. That JSON file is used by the frontend to locate the contract on the blockchain. Therefore, if you were to implement a common Dev, QA, Prod pipeline you would have to rebuild your frontend to incorporate the address of the contract on each blockchain representing Dev, QA, and Prod. Code should only be built once and those bits deployed to each environment. To address this instead of reading the address from a static file I changed the default React code to call an API that would return the address of the contract on the blockchain. This follows the best practice of only changing configuration and scale as you move through your pipeline. Instead of having to recompile my frontend I simply update its configuration with the new address.

Code Before

```javascript
const deployedNetwork = SimpleStorageContract.networks[networkId];
const instance = new web3.eth.Contract(
    SimpleStorageContract.abi,
    deployedNetwork && deployedNetwork.address,
);
```

Code After

```javascript
const deployedNetwork = SimpleStorageContract.networks[networkId];

let contractAddress = deployedNetwork && deployedNetwork.address;

// If the network can't be found in the contract JSON call the 
// backend API for the address.
if (!contractAddress) {
    console.log('Address not found in contract JSON. Calling backup api');
    contractAddress = await(await fetch(`/api/GetContractAddress`)).text();
}

const instance = new web3.eth.Contract(
    SimpleStorageContract.abi,
    contractAddress,
);
```