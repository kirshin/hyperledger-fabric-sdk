require_relative 'fabric_ca/error'
require_relative 'fabric_ca/configuration'
require_relative 'fabric_ca/client'
require_relative 'fabric_ca/response'
require_relative 'fabric_ca/version'
require_relative 'fabric_ca/tools'

module FabricCA
  extend Configuration

  def self.client(options = {})
    FabricCA::Client.new(options)
  end
end
