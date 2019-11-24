module Fabric
  class EventHub < ClientStub
    MAX_BLOCK_NUMBER = 4_611_686_018_427_387_903.freeze

    def client
      @client ||= ::Protos::Deliver::Stub.new host, creds, options
    end

    def queue
      @queue ||= Fabric::EnumeratorQueue.new client
    end

    def connection
      @connection ||= client.deliver(queue.each).each
    end

    def observe(channel_id, identity, start_block = :newest, stop_block = MAX_BLOCK_NUMBER)
      tx_info = Fabric::TransactionInfo.new identity
      seek_header = build_seek_header channel_id, tx_info
      seek_info = build_seek_info start_block, stop_block
      envelope = build_envelope tx_info, seek_header, seek_info

      loop do
        queue.push envelope

        event = connection.next

        block = Fabric::BlockDecoder.decode_block(event.block)

        yield block if block_given?
      end
    end

    private

    def build_envelope(tx_info, seek_header, seek_info)
      seek_payload = ::Common::Payload.new(
        header: seek_header,
        data: seek_info.to_proto
      )

      ::Common::Envelope.new signature: tx_info.identity.sign(seek_payload.to_proto),
                             payload: seek_payload.to_proto
    end

    def build_seek_header(channel_id, tx_info)
      seek_info_header = Fabric::Helper.build_channel_header(
        type: ::Common::HeaderType::DELIVER_SEEK_INFO,
        channel_id: channel_id,
        tx_id: tx_info.tx_id
      )

      ::Common::Header.new(
        channel_header: seek_info_header.to_proto,
        signature_header: tx_info.signature_header.to_proto
      )
    end

    def build_seek_info(start_block, stop_block)
      ::Orderer::SeekInfo.new(
        start: build_seek_position(start_block),
        stop: build_seek_position(stop_block),
        behavior: ::Orderer::SeekInfo::SeekBehavior::BLOCK_UNTIL_READY
      )
    end

    def build_seek_position(block_number)
      case block_number
      when :newest then ::Orderer::SeekPosition.new(newest: ::Orderer::SeekNewest.new)
      when :oldest then ::Orderer::SeekPosition.new(oldest: ::Orderer::SeekOldest.new)
      else
        ::Orderer::SeekPosition.new(
          specified: ::Orderer::SeekSpecified.new(number: block_number)
        )
      end
    end
  end
end
