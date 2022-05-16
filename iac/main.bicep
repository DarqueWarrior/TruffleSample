targetScope = 'subscription'

param repoUrl string
param swaName string = 'web3swa'
param location string = 'centralus'
param rgName string = 'truffle_demo'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module web3swa './swa.bicep' = {
  name: swaName
  scope: resourceGroup(rg.name)
  params: {
    repoToken: ''
    repoUrl: repoUrl
    location: location
  }
}

output deploymentToken string = web3swa.outputs.deploymentToken
