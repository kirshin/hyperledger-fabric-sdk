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

require 'common/common_pb'
require 'common/configtx_pb'

module Fabric
  extend Configuration

  def self.client(options = {})
    client = Fabric::Client.new options

    orderers.each { |url| client.new_orderer url }
    peers.each { |url| client.new_peer url }

    client
  end
end
