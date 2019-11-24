#!/Users/djlazz3/.rbenv/shims/ruby
require_relative './initialize.rb'

user = Fabric::Identity.new(
  Fabric.crypto_suite,
  {
    username: "admin",
    affiliation: "org1.department1",
    mspid: 'Org1MSP'
  }
).generate_csr([%w(CN admin)])

fabric_ca_client = FabricCA.client(username: "admin",  password: "adminpw")

puts fabric_ca_client.enroll(user)
