#!/Users/djlazz3/.rbenv/shims/ruby
require 'hyperledger-fabric-sdk'

fabric_ca_client = FabricCA.client(
  endpoint: "http://localhost:7054",
  username: "admin",
  password: "adminpw"
)

fabric_sdk = Fabric.new(
  orderers: ["localhost:7050"],
  peers: ["localhost:7051", "localhost:8051"]
)

user_identity = Fabric::Identity.new(
  Fabric.crypto_suite,
  {
    username: "admin",
    affiliation: "org1.department1",
    mspid: 'Org1MSP'
  }
)

enrollment_response = fabric_ca_client.enroll(user_identity.generate_csr([%w(CN admin)]))

user_identity.certificate = enrollment_response[:result][:Cert]

fabric_client = fabric_sdk.client(identity: user_identity)

puts fabric_client.query(
  chaincode_id: "fabcar",
  channel_id: 'mychannel',
  args: ["initLedger"]
)
