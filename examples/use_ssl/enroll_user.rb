#!/Users/djlazz3/.rbenv/shims/ruby
require 'hyperledger-fabric-sdk'

fabric_ca_client = FabricCA.new(
  endpoint: "https://localhost:7054",
  username: "admin",
  password: "adminpw",
  connection_opts: {
    ssl: { verify: false }
  }
)

crypto_suite = Fabric.crypto_suite

user = Fabric::Identity.new(
  crypto_suite,
  {
    username: "admin",
    affiliation: "org1.department1",
    mspid: 'Org1MSP'
  }
).generate_csr([%w(CN admin)])

fabric_ca_client.enroll(user)
