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

## Invoke
fabric_client = Fabric.client(identity: user_identity)

transaction = fabric_client.invoke(chaincode_id: "mycc", channel_id: 'mychannel',  args: %w(invoke a b 1))

puts transaction.tx_id

10.times do
  begin
    responses = fabric_client.query(
                  chaincode_id: "qscc",
                  channel_id: 'mychannel',
                  args: ['GetTransactionByID', 'mychannel', transaction.tx_id]
                )

    processed_transaction = Protos::ProcessedTransaction.decode responses.first

    puts Protos::TxValidationCode.lookup processed_transaction.validationCode
  rescue Fabric::UnknownError => ex
    puts ex.message

    sleep 1
  end
end
