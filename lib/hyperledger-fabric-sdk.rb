lib_dir = File.join(File.expand_path(File.dirname(__FILE__)), 'protos')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require_relative 'fabric/version'
require_relative 'fabric/configuration'
require_relative 'fabric/constants'
require_relative 'fabric/client'
require_relative 'fabric/peer_endorser'
require_relative 'fabric/transaction_id'
require_relative 'fabric/channel'
require_relative 'fabric/peer'
require_relative 'fabric/orderer'
require_relative 'fabric/user'
require_relative 'fabric/identity'

require_relative 'fabric_ca/error'
require_relative 'fabric_ca/configuration'
require_relative 'fabric_ca/client'
require_relative 'fabric_ca/response'
require_relative 'fabric_ca/version'
require_relative 'fabric_ca/tools'

require_relative 'crypto_suite/ecdsa_aes'

require 'common/common_pb'
require 'common/configtx_pb'

module Fabric
  extend Configuration

  def self.new(config)
    client = Fabric::Client.new config[:options]

    config[:orderer_urls].each { |url| client.new_orderer url }
    config[:peer_urls].each { |url| client.new_peer url }

    client
  end
end

module FabricCA
  extend Configuration

  def self.new(options = {})
    FabricCA::Client.new(options)
  end
end
