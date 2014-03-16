module Elastic
  module DocumentsPercolator

    class StoreCommand < Operation
      attr_reader :category

      def initialize(category)
        @category = category
      end

      def perform
        params = address.merge id: category.id, body: attributes
        POOL.with { |client| client.index params }
      end

    private
      def attributes
        Elastic::Shared::CategoryQuery.query category
      end
    end

  end
end