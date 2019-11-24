#!/Users/djlazz3/.rbenv/shims/ruby
require_relative './initialize.rb'

## Enroll admin
fabric_ca_client = FabricCA.client(username: 'admin',  password: 'adminpw')
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

## EventHub
fabric_client = Fabric.client(identity: user_identity)

event_hub = fabric_client.event_hubs.first

start_block = 1
stop_block = Fabric::EventHub::MAX_BLOCK_NUMBER

event_hub.observe('mychannel', user_identity, start_block, stop_block) do |block|
  tx_validation_codes = block[:metadata][:metadata][2]

  block[:data][:data].each_with_index do |data, index|
    tx_validation_code = Protos::TxValidationCode.lookup(tx_validation_codes[index]).to_s

    puts id: data[:payload][:header][:channel_header][:tx_id],
         timestamp: data[:payload][:header][:channel_header][:timestamp],
         validation_code: tx_validation_code
  end
end
