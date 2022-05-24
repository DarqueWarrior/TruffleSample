param location string

resource ganache 'Microsoft.ContainerInstance/containerGroups@2021-10-01' = {
  name: 'ganache${uniqueString(resourceGroup().id)}'
  location: location
  tags: {
    tagName1: 'demo'
  }
  properties: {
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: 8545
          protocol: 'TCP'
        }
      ]
    }
    containers: [
      {
        name: 'ganache'
        properties: {
          command: [
            'node'
            '/app/dist/node/cli.js'
            '--wallet.totalAccounts'
            '4'
            '--wallet.deterministic'
            '--chain.chainId'
            '1352'
          ]
          image: 'trufflesuite/ganache:latest'
          ports: [
            {
              port: 8545
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: json('1.5')
            }
          }
        }
      }
    ]
  }
}

output ganacheIp string = ganache.properties.ipAddress.ip
