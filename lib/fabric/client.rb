module Fabric
  class Client
    attr_reader :identity_context, :orderers, :peers, :channels

    def initialize(options = {})
      options = Fabric.options.merge(options)

      @identity_context = options[:identity_context]
      @orderers = {}
      @channels = {}
      @peers = {}
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = public_send key
      end

      conf
    end

    def new_channel(name)
      channels[name] ||= Channel.new name: name,
                                     orderers: orderers.values , peers: peers.values,
                                     identity_context: identity_context

      channels[name]
    end

    def new_peer(url, opts = {})
      peers[url] ||= Peer.new url: url, opts: opts,
                              identity_context: identity_context

      peers[url]
    end

    def new_orderer(url, opts = {})
      orderers[url] ||= Orderer.new url: url, opts: opts,
                                    identity_context: identity_context

      orderers[url]
    end
  end
end
