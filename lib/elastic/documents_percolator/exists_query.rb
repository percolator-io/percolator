module Elastic
  module DocumentsPercolator

    class ExistsQuery < Operation
      attr_reader :category

      def initialize(category)
        @category = category
      end

      def result
        POOL.with { |client| client.exists address.merge id: category.id }
      end
    end

  end
end
