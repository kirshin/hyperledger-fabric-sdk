module Fabric
  class EventHub
    attr_reader :url, :identity, :logger, :crypto_suite, :channel_id
    attr_reader :channel, :connection, :queue

    MAX_BLOCK_NUMBER = 1_000_000_000

    def initialize(opts = {})
      @url = opts[:url]
      @identity = opts[:identity]
      @crypto_suite = opts[:crypto_suite]
      @logger = opts[:logger]
      @channel_id = opts[:channel_id]

      @channel = ::Protos::Deliver::Stub.new url, :this_channel_is_insecure
      @queue = Fabric::EnumeratorQueue.new channel
      @connection = channel.deliver(queue.each).each
    end

    def observe(start_block = :newest, stop_block = MAX_BLOCK_NUMBER)
      tx_info = Fabric::TransactionInfo.new crypto_suite, identity
      seek_header = build_seek_header tx_info
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

    def build_seek_header(tx_info)
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
