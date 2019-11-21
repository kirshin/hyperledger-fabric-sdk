#!/Users/djlazz3/.rbenv/shims/ruby
require 'hyperledger-fabric-sdk'

fabric_ca_client = FabricCA.new(
  endpoint: "http://localhost:7054",
  username: "admin",
  password: "adminpw"
)

fabric_sdk = Fabric.new(
  orderers: ["localhost:7050"],
  peers: ["localhost:7051", "localhost:8051"]
)

crypto_suite = Fabric.crypto_suite

user_identity = Fabric::Identity.new(
  crypto_suite,
  {
    username: "admin",
    affiliation: "org1.department1",
    mspid: 'Org1MSP'
  }
)

enrollment_response = fabric_ca_client.enroll(user_identity.generate_csr([%w(CN admin)]))

user_identity.certificate = enrollment_response[:result][:Cert]

fabric_client = fabric_sdk.client(
  identity: user_identity,
  crypto_suite: crypto_suite
)

fabric_client.query(
  chaincode_id: "fabcar",
  channel_id: 'mychannel',
  args: ["initLedger"]
)
