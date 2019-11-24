lib_dir = File.join(__dir__, 'fabric/protos')

$LOAD_PATH.push(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'colorize'

require 'common/common_pb'
require 'common/configtx_pb'
require 'peer/events_services_pb'
require 'ledger/rwset/rwset_pb'
require 'ledger/rwset/kvrwset/kv_rwset_pb'

require_relative 'fabric/version'
require_relative 'fabric/configuration'
require_relative 'fabric/constants'
require_relative 'fabric/client'
require_relative 'fabric/peer'
require_relative 'fabric/orderer'
require_relative 'fabric/enumerator_queue'
require_relative 'fabric/crypto_suite'
require_relative 'fabric/identity'
require_relative 'fabric/proposal'
require_relative 'fabric/transaction'
require_relative 'fabric/error'
require_relative 'fabric/logger'
require_relative 'fabric/chaincode_response'
require_relative 'fabric/channel'
require_relative 'fabric/transaction_info'
require_relative 'fabric/helper'
require_relative 'fabric/block_decoder'
require_relative 'fabric/event_hub'

module Fabric
  extend Configuration
  @orderers = []
  @peers = []

  def self.new(config)
    @orderers = config[:orderers]
    @peers = config[:peers]
    self
  end

  def self.client(opts = {})
    client = Fabric::Client.new opts

    orderers.each { |config| client.register_orderer config }
    peers.each { |config| client.register_peer config }
    event_hubs.each { |config| client.register_event_hub config }

    client
  end

  def self.channel(opts = {})
    channel = Fabric::Channel.new opts

    @orderers.each { |url| channel.register_orderer url, opts }
    @peers.each { |url| channel.register_peer url, opts }

    channel
  end

  def self.event_hub(opts = {})
    options = Fabric.options.merge opts

    options[:crypto_suite] ||= Fabric.crypto_suite
    options[:url] = options[:event_hub_url]

    Fabric::EventHub.new options
  end

  def self.crypto_suite(opts = {})
    @crypto_suite ||= Fabric::CryptoSuite.new opts
  end
end
