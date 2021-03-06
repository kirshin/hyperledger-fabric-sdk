# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: peer/chaincode_shim.proto

require 'google/protobuf'

require 'peer/chaincode_event_pb'
require 'peer/proposal_pb'
require 'google/protobuf/timestamp_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message 'protos.ChaincodeMessage' do
    optional :type, :enum, 1, 'protos.ChaincodeMessage.Type'
    optional :timestamp, :message, 2, 'google.protobuf.Timestamp'
    optional :payload, :bytes, 3
    optional :txid, :string, 4
    optional :proposal, :message, 5, 'protos.SignedProposal'
    optional :chaincode_event, :message, 6, 'protos.ChaincodeEvent'
    optional :channel_id, :string, 7
  end
  add_enum 'protos.ChaincodeMessage.Type' do
    value :UNDEFINED, 0
    value :REGISTER, 1
    value :REGISTERED, 2
    value :INIT, 3
    value :READY, 4
    value :TRANSACTION, 5
    value :COMPLETED, 6
    value :ERROR, 7
    value :GET_STATE, 8
    value :PUT_STATE, 9
    value :DEL_STATE, 10
    value :INVOKE_CHAINCODE, 11
    value :RESPONSE, 13
    value :GET_STATE_BY_RANGE, 14
    value :GET_QUERY_RESULT, 15
    value :QUERY_STATE_NEXT, 16
    value :QUERY_STATE_CLOSE, 17
    value :KEEPALIVE, 18
    value :GET_HISTORY_FOR_KEY, 19
    value :GET_STATE_METADATA, 20
    value :PUT_STATE_METADATA, 21
  end
  add_message 'protos.GetState' do
    optional :key, :string, 1
    optional :collection, :string, 2
  end
  add_message 'protos.GetStateMetadata' do
    optional :key, :string, 1
    optional :collection, :string, 2
  end
  add_message 'protos.PutState' do
    optional :key, :string, 1
    optional :value, :bytes, 2
    optional :collection, :string, 3
  end
  add_message 'protos.PutStateMetadata' do
    optional :key, :string, 1
    optional :collection, :string, 3
    optional :metadata, :message, 4, 'protos.StateMetadata'
  end
  add_message 'protos.DelState' do
    optional :key, :string, 1
    optional :collection, :string, 2
  end
  add_message 'protos.GetStateByRange' do
    optional :startKey, :string, 1
    optional :endKey, :string, 2
    optional :collection, :string, 3
    optional :metadata, :bytes, 4
  end
  add_message 'protos.GetQueryResult' do
    optional :query, :string, 1
    optional :collection, :string, 2
    optional :metadata, :bytes, 3
  end
  add_message 'protos.QueryMetadata' do
    optional :pageSize, :int32, 1
    optional :bookmark, :string, 2
  end
  add_message 'protos.GetHistoryForKey' do
    optional :key, :string, 1
  end
  add_message 'protos.QueryStateNext' do
    optional :id, :string, 1
  end
  add_message 'protos.QueryStateClose' do
    optional :id, :string, 1
  end
  add_message 'protos.QueryResultBytes' do
    optional :resultBytes, :bytes, 1
  end
  add_message 'protos.QueryResponse' do
    repeated :results, :message, 1, 'protos.QueryResultBytes'
    optional :has_more, :bool, 2
    optional :id, :string, 3
    optional :metadata, :bytes, 4
  end
  add_message 'protos.QueryResponseMetadata' do
    optional :fetched_records_count, :int32, 1
    optional :bookmark, :string, 2
  end
  add_message 'protos.StateMetadata' do
    optional :metakey, :string, 1
    optional :value, :bytes, 2
  end
  add_message 'protos.StateMetadataResult' do
    repeated :entries, :message, 1, 'protos.StateMetadata'
  end
end

module Protos
  ChaincodeMessage = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.ChaincodeMessage').msgclass
  ChaincodeMessage::Type = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.ChaincodeMessage.Type').enummodule
  GetState = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.GetState').msgclass
  GetStateMetadata = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.GetStateMetadata').msgclass
  PutState = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.PutState').msgclass
  PutStateMetadata = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.PutStateMetadata').msgclass
  DelState = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.DelState').msgclass
  GetStateByRange = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.GetStateByRange').msgclass
  GetQueryResult = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.GetQueryResult').msgclass
  QueryMetadata = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.QueryMetadata').msgclass
  GetHistoryForKey = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.GetHistoryForKey').msgclass
  QueryStateNext = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.QueryStateNext').msgclass
  QueryStateClose = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.QueryStateClose').msgclass
  QueryResultBytes = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.QueryResultBytes').msgclass
  QueryResponse = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.QueryResponse').msgclass
  QueryResponseMetadata = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.QueryResponseMetadata').msgclass
  StateMetadata = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.StateMetadata').msgclass
  StateMetadataResult = Google::Protobuf::DescriptorPool.generated_pool.lookup('protos.StateMetadataResult').msgclass
end
