module Fabric
  class BlockDecoder
    def self.decode_block(proposal_block)
      {
        header: decode_block_header(proposal_block),
        data: decode_block_data(proposal_block.data),
        metadata: decode_block_metadata(proposal_block.metadata)
      }
    end

    private

    def self.decode_block_metadata(proto_block_metadata)
      return {} unless proto_block_metadata.metadata

      {
        metadata: [
          decode_metadata_signatures(proto_block_metadata.metadata[0]),
          decode_last_config_sequence_number(proto_block_metadata.metadata[1]),
          decode_transaction_filter(proto_block_metadata.metadata[2])
        ]
      }
    end

    def self.decode_transaction_filter(metadata_data)
      return unless metadata_data

      metadata_data.bytes
    end

    def self.decode_last_config_sequence_number(metadata_data)
      return { value: {} } unless metadata_data

      proto_metadata = Common::Metadata.decode(metadata_data)
      proto_last_config = Common::LastConfig.decode(proto_metadata.value)

      {
        value: {
          index: proto_last_config.index
        },
        signatures: decode_metadata_value_signatures(proto_metadata.signatures)
      }
    end

    def self.decode_metadata_signatures(metadata_data)
      proto_metadata = Common::Metadata.decode(metadata_data)

      {
        value: proto_metadata.value,
        signatures: decode_metadata_value_signatures(proto_metadata.signatures)
      }
    end

    def decode_metadata_value_signatures(proto_meta_signatures)
      Array.wrap(proto_meta_signatures).map do |meta_signature_data|
        proto_metadata_signature = Common::MetadataSignature.decode(meta_signature_data)

        {
          signature_header: decode_signature_header(proto_metadata_signature.signature_header),
          signature: Fabric.crypto_suite.encode_hex(proto_metadata_signature.signature)
        }
      end
    end

    def self.decode_metadata_value_signatures(proto_meta_signatures); end

    def self.decode_block_header(block_data)
      {
        number: block_data.header.number,
        previous_hash: Fabric.crypto_suite.encode_hex(block_data.header.previous_hash),
        data_hash: Fabric.crypto_suite.encode_hex(block_data.header.data_hash)
      }
    end

    def self.decode_block_data(proto_block_data)
      data = { data: [] }

      proto_block_data.data.each do |envelope_data|
        proto_envelope = Common::Envelope.decode envelope_data

        data[:data].push decode_block_data_envelope(proto_envelope)
      end

      data
    end

    def self.decode_block_data_envelope(proto_envelope)
      envelope = { payload: {} }
      envelope[:signature] = Fabric.crypto_suite.encode_hex proto_envelope.signature
      proto_payload = Common::Payload.decode(proto_envelope.payload)
      envelope[:payload][:header] = decode_payload_header proto_payload.header
      envelope[:payload][:data] =
        decode_payload_based_on_type proto_payload.data,
                                     envelope[:payload][:header][:channel_header][:type]

      envelope
    end

    def self.decode_payload_header(proto_header)
      header = {}
      header[:channel_header] = decode_channel_header proto_header.channel_header
      header[:signature_header] = decode_signature_header proto_header.signature_header

      header
    end

    def self.decode_channel_header(channel_header_data)
      channel_header = {}

      proto_channel_header = Common::ChannelHeader.decode channel_header_data
      channel_header[:type] = proto_channel_header.type
      channel_header[:version] = proto_channel_header.version
      channel_header[:timestamp] = Helper.timestamp_to_time proto_channel_header.timestamp
      channel_header[:channel_id] = proto_channel_header.channel_id
      channel_header[:tx_id] = proto_channel_header.tx_id
      channel_header[:epoch] = proto_channel_header.epoch
      channel_header[:extension] = decode_payload_header_extension proto_channel_header.extension

      channel_header
    end

    def self.decode_payload_header_extension(extension_data)
      return unless extension_data

      Protos::ChaincodeHeaderExtension.decode(extension_data)
    end

    def self.decode_signature_header(signature_header_data)
      signature_header = {}
      proto_signature_header = Common::SignatureHeader.decode signature_header_data
      signature_header[:creator] = decode_identity proto_signature_header.creator
      signature_header[:nonce] = Fabric.crypto_suite.encode_hex proto_signature_header.nonce

      signature_header
    end

    def self.decode_identity(creator_data)
      identity = {}

      proto_identity = Msp::SerializedIdentity.decode creator_data
      identity[:mspid] = proto_identity.mspid
      identity[:id_bytes] = proto_identity.id_bytes

      identity
    end

    def self.decode_payload_based_on_type(proto_data, type)
      case type
      when Common::HeaderType::CONFIG then {}
      when Common::HeaderType::CONFIG_UPDATE then {}
      when Common::HeaderType::ENDORSER_TRANSACTION then decode_endorser_transaction proto_data
      else {}
      end
    end

    def self.decode_endorser_transaction(transaction_data)
      proto_transaction = Protos::Transaction.decode transaction_data

      {
        actions: proto_transaction.actions.map do |proto_action|
                   {
                     header: decode_signature_header(proto_action.header),
                     payload: decode_chaincode_action_payload(proto_action.payload)
                   }
                 end
      }
    end

    def self.decode_chaincode_action_payload(payload_data)
      proto_payload = Protos::ChaincodeActionPayload.decode payload_data

      {
        chaincode_proposal_payload:
          decode_chaincode_proposal_payload(proto_payload.chaincode_proposal_payload),
        action:
          decode_chaincode_endorsed_action(proto_payload.action)
      }
    end

    def self.decode_chaincode_proposal_payload(payload_data)
      proto_chaincode_proposal_payload = Protos::ChaincodeProposalPayload.decode payload_data

      {
        input: decode_chaincode_proposal_payload_input(proto_chaincode_proposal_payload.input)
      }
    end

    def self.decode_chaincode_proposal_payload_input(input_data)
      Protos::ChaincodeInvocationSpec.decode(input_data)
    end

    def self.decode_chaincode_input(input_data)
      proto_chaincode_input = Protos::ChaincodeInput.decode input_data

      proto_chaincode_input
    end

    def self.decode_chaincode_endorsed_action(proto_action)
      {
        proposal_response_payload:
          decode_proposal_response_payload(proto_action.proposal_response_payload),
        endorsements:
          proto_action.endorsements.map do |proto_endorsement|
            decode_endorsement proto_endorsement
          end
      }
    end

    def self.decode_endorsement(proto_endorsement)
      {
        endorser: decode_identity(proto_endorsement.endorser),
        signature: Fabric.crypto_suite.encode_hex(proto_endorsement.signature)
      }
    end

    def self.decode_proposal_response_payload(proposal_response_payload_bytes)
      proposal_response_payload = {}
      proto_proposal_response_payload =
        Protos::ProposalResponsePayload.decode proposal_response_payload_bytes
      proposal_response_payload[:proposal_hash] =
        Fabric.crypto_suite.encode_hex proto_proposal_response_payload.proposal_hash
      proposal_response_payload[:extension] =
        decode_chaincode_action proto_proposal_response_payload.extension

      proposal_response_payload
    end

    def self.decode_chaincode_action(action_data)
      proto_chaincode_action = Protos::ChaincodeAction.decode action_data

      {
        results: decode_read_write_sets(proto_chaincode_action.results),
        events: decode_chaincode_events(proto_chaincode_action.events),
        response: decode_response(proto_chaincode_action.response),
        chaincode_id: decode_chaincode_id(proto_chaincode_action.chaincode_id)
      }
    end

    def self.decode_read_write_sets(rw_sets_data)
      proto_tx_read_write_set = Rwset::TxReadWriteSet.decode rw_sets_data
      tx_read_write_set = { data_model: proto_tx_read_write_set.data_model }
      ns_rwset = proto_tx_read_write_set.ns_rwset

      tx_read_write_set[:ns_rwset] =
        if proto_tx_read_write_set.data_model == :KV
          decode_ns_rwset ns_rwset
        else
          ns_rwset
        end

      tx_read_write_set
    end

    def self.decode_ns_rwset(ns_rwset)
      ns_rwset.map do |proto_ns_rwset|
        {
          namespace: proto_ns_rwset.namespace,
          rwset: decode_kv_rw_set(proto_ns_rwset.rwset),
          collection_hashed_rwset:
            decode_collection_hashed_rw_set(proto_ns_rwset.collection_hashed_rwset)
        }
      end
    end

    def self.decode_kv_rw_set(rwset_data)
      Kvrwset::KVRWSet.decode(rwset_data)
    end

    def self.decode_collection_hashed_rw_set(proto_collection_hashed_rwset)
      proto_collection_hashed_rwset.map do |proto_hashed_rwset|
        {
          collection_name: proto_hashed_rwset.collection_name,
          decode_hashed_rwset: decode_hashed_rwset(proto_hashed_rwset.hashed_rwset_data),
          pvt_rwset_hash: proto_hashed_rwset.pvt_rwset_hash
        }
      end
    end

    def self.decode_hashed_rwset(hashed_rwset_data)
      Rwset::HashedRWSet.decode(hashed_rwset_data)
    end

    def self.decode_chaincode_events(event_data)
      Protos::ChaincodeEvent.decode(event_data)
    end

    def self.decode_response(proposal_response)
      return unless proposal_response

      proposal_response
    end

    def self.decode_chaincode_id(chaincode_id)
      return unless chaincode_id

      chaincode_id
    end
  end
end
