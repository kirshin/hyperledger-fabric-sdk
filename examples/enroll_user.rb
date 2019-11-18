#!/Users/djlazz3/.rbenv/shims/ruby
require 'hyperledger-fabric-sdk'

crypto_suite = CryptoSuite::ECDSA_AES.new()

ca_client = FabricCA.new(
  endpoint: "http://localhost:7054",
  username: "admin",
  password: "adminpw"
)

client = Fabric.new(
  orderer_urls: ["grpc://localhost:7050"],
  peer_urls: ["grpc://localhost:7051", "grpc://localhost:8051"],
  options: {}
)

client.new_channel(:mychannel)

p ca_client

user = Fabric::User.new(
  username: 'admin',
  crypto_suite: crypto_suite,
  affiliation: 'org1.department1'
)

p ca_client.enroll(user, "Org1MSP")

# p client
