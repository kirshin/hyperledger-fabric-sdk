require 'hyperledger-fabric-sdk'

FabricCA.configure do |config|
  config.endpoint = 'https://localhost:7054'
  config.ca_name = 'ca-org1'
  config.connection_opts = { ssl: { verify: false } }
end



Fabric.configure do |config|
  config.crypto_suite = Fabric.crypto_suite
  config.peers = [
    {
      url: "localhost:7051",
      tls_ca_cert: File.read('crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt'),
      grpc_options: {
        "grpc.ssl_target_name_override": "peer0.org1.example.com"
      }
    }
  ]
  config.orderers = [
    {
      url: "localhost:7050",
      tls_ca_cert: File.read('crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt'),
      grpc_options: {
        "grpc.ssl_target_name_override": "orderer.example.com"
      }
    }
  ]
  config.event_hubs = [
    {
      url: "localhost:7051",
      tls_ca_cert: File.read('crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt'),
      grpc_options: {
        "grpc.ssl_target_name_override": "peer0.org1.example.com"
      }
    }
  ]
end
