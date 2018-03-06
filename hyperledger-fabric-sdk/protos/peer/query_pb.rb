# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: peer/query.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "protos.ChaincodeQueryResponse" do
    repeated :chaincodes, :message, 1, "protos.ChaincodeInfo"
  end
  add_message "protos.ChaincodeInfo" do
    optional :name, :string, 1
    optional :version, :string, 2
    optional :path, :string, 3
    optional :input, :string, 4
    optional :escc, :string, 5
    optional :vscc, :string, 6
  end
  add_message "protos.ChannelQueryResponse" do
    repeated :channels, :message, 1, "protos.ChannelInfo"
  end
  add_message "protos.ChannelInfo" do
    optional :channel_id, :string, 1
  end
end

module Protos
  ChaincodeQueryResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeQueryResponse").msgclass
  ChaincodeInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChaincodeInfo").msgclass
  ChannelQueryResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChannelQueryResponse").msgclass
  ChannelInfo = Google::Protobuf::DescriptorPool.generated_pool.lookup("protos.ChannelInfo").msgclass
end