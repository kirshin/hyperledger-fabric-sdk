require_relative 'fabric_ca/version'
require_relative 'fabric_ca/configuration'
require_relative 'fabric_ca/error'
require_relative 'fabric_ca/connection'
require_relative 'fabric_ca/request'
require_relative 'fabric_ca/response'
require_relative 'fabric_ca/client'
require_relative 'fabric_ca/attribute'

module FabricCA
  extend Configuration

  def self.new(options = {})
    FabricCA::Client.new(options)
  end
end
