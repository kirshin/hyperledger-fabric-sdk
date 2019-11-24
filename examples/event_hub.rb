require 'hyperledger-fabric-sdk'

fabric_ca_client = FabricCA.client(
  endpoint: "http://localhost:7054",
  username: "admin",
  password: "adminpw"
)

user_identity = Fabric::Identity.new(
  Fabric.crypto_suite,
  {
    username: "admin",
    affiliation: "org1.department1",
    mspid: 'Org1MSP'
  }
)

fabric_sdk = Fabric.new(
  orderers: ["localhost:7050"],
  peers: ["localhost:7051", "localhost:8051"],
  event_hubs: ["localhost:7051"]
)

enrollment_response = fabric_ca_client.enroll(user_identity.generate_csr([%w(CN admin)]))

user_identity.certificate = enrollment_response[:result][:Cert]

fabric_client = fabric_sdk.client(identity: user_identity)

start_block = 0
stop_block = Fabric::EventHub::MAX_BLOCK_NUMBER

fabric_client.event_hubs.first.observe('mychannel', user_identity, start_block, stop_block) do |block|
  tx_validation_codes = block[:metadata][:metadata][2]

  block[:data][:data].each_with_index do |data, index|
    tx_validation_code = Protos::TxValidationCode.lookup(tx_validation_codes[index]).to_s

    puts id: data[:payload][:header][:channel_header][:tx_id],
         timestamp: data[:payload][:header][:channel_header][:timestamp],
         validation_code: tx_validation_code
  end
end
