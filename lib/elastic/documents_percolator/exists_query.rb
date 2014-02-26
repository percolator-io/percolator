module Elastic
  module DocumentsPercolator

    class ExistsQuery < Operation
      attr_reader :id

      def initialize(id)
        @id = id
      end

      def result
        POOL.with { |client| client.exists address.merge id: id }
      end
    end

  end
end