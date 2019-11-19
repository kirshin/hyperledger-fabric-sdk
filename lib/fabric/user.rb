module Fabric
  class User
    attr_reader :username, :roles, :affiliation,
                :identity, :crypto_suite

    def initialize(args)
      @crypto_suite = args[:crypto_suite]
      @username = args[:username]
      @roles = args[:roles] || []
      @affiliation = args[:affiliation]
      @identity = nil
    end

    def enroll(opts)
      opts[:crypto_suite] = crypto_suite

      @identity = Identity.new opts
    end

    def enrolled?
      identity
    end
  end
end
