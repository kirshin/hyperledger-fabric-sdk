require 'logger'
require 'hyperledger-fabric-sdk'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

FabricCA.configure do |config|
  config.logger = logger
  config.endpoint = 'https://localhost:7054'
  config.ca_name = 'ca-org1'
  config.connection_opts = { ssl: { verify: false } }
end

Fabric.configure do |config|
  config.logger = logger
  config.crypto_suite = Fabric.crypto_suite
  config.peers = [
    {
      host: "localhost:7051",
      creds: File.read('crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt'),
      channel_args: {
        "grpc.ssl_target_name_override": "peer0.org1.example.com"
      }
    }
  ]
  config.orderers = [
    {
      host: "localhost:7050",
      creds: File.read('crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt'),
      channel_args: {
        "grpc.ssl_target_name_override": "orderer.example.com"
      }
    }
  ]
  config.event_hubs = [
    {
      host: "localhost:7051",
      creds: File.read('crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt'),
      channel_args: {
        "grpc.ssl_target_name_override": "peer0.org1.example.com"
      }
    }
  ]
end
