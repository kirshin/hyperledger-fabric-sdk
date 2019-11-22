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

user_identity = Fabric::Identity.new(
  crypto_suite,
  {
    username: "admin",
    affiliation: "org1.department1",
    mspid: 'Org1MSP'
  }
)

data_dir = "../../crypto-config/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls"
files = ['ca.crt', 'server.key', 'server.crt']
certs = files.map { |f| File.open(File.join(data_dir, f)).read }
channel_creds = GRPC::Core::ChannelCredentials.new(certs)

enrollment_response = fabric_ca_client.enroll(user_identity.generate_csr([%w(CN admin)]))

user_identity.certificate = enrollment_response[:result][:Cert]

event_hub = Fabric.event_hub identity: user_identity,
                             channel_id: 'mychannel',
                             event_hub_url: 'localhost:7051',
                             channel_creds: channel_creds

start_block = 1
stop_block = Fabric::EventHub::MAX_BLOCK_NUMBER

event_hub.observe(start_block, stop_block) do |block|
  tx_validation_codes = block[:metadata][:metadata][2]

  block[:data][:data].each_with_index do |data, index|
    tx_validation_code = Protos::TxValidationCode.lookup(tx_validation_codes[index]).to_s

    {
      id: data[:payload][:header][:channel_header][:tx_id],
      timestamp: data[:payload][:header][:channel_header][:timestamp],
      validation_code: tx_validation_code
    }
  end
end
