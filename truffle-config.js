const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
      host: "20.221.19.24",
      port: 8545,
      network_id: '*'
    },
    rinkeby: {
      host: "localhost",
      provider: function () {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/" + projectId);
      },
      network_id: 4,
      gas: 6700000,
      gasPrice: 10000000000
    },
    develop: {
      port: 8545
    }
  },
  mocha: {
    reporter: 'xunit',
    reporterOptions: {
      output: 'TEST-results.xml'
    }
  }
};
