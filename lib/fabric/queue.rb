module Fabric
  class EnumeratorQueue
    extend Forwardable
    def_delegators :@q, :push
    def_delegators :@q, :size

    def initialize(sentinel)
      @q = Queue.new
      @sentinel = sentinel
    end

    def each
      return enum_for(:each) unless block_given?

      loop do
        r = @q.pop

        break if r.equal?(@sentinel)

        raise r if r.is_a? Exception

        yield r
      end
    end
  end
end
