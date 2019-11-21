module Fabric
  module Helper
    def self.build_channel_header(opts)
      header = Common::ChannelHeader.new type: opts[:type],
                                         channel_id: opts[:channel_id],
                                         tx_id: opts[:tx_id],
                                         timestamp: opts[:timestamp] || build_timestamp,
                                         version: 1

      header.extension = build_channel_header_extension(opts) if opts[:chaincode_id]

      header
    end

    def self.build_channel_header_extension(opts)
      id = Protos::ChaincodeID.new name: opts[:chaincode_id]

      Protos::ChaincodeHeaderExtension.new chaincode_id: id
    end

    def self.build_timestamp
      now = Time.now

      Google::Protobuf::Timestamp.new seconds: now.to_i, nanos: now.nsec
    end

    def self.timestamp_to_time(timestamp)
      (timestamp.seconds * 1000 + timestamp.nanos / 10**6).to_i
    end
  end
end
