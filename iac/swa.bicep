param repoUrl string
param location string
param repoToken string

resource swa 'Microsoft.Web/staticSites@2021-03-01' = {
  name: 'swa${uniqueString(resourceGroup().id)}'
  location: location
  tags: {
    tagName1: 'demo'
  }
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    branch: 'main'
    repositoryUrl: repoUrl
    repositoryToken: repoToken
    buildProperties: {
      apiLocation: ''
      appLocation: '/'
      appArtifactLocation: 'dist'
    }
  }
}

output deploymentToken string = swa.listSecrets().properties.apiKey
