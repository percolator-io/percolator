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
      #TODO: избавиться от дублирования
      def attributes
        {
          query: {
            query_string: {
              query: category.query,
              fields: %w(title description keywords host),
            }
          }
        }
      end
    end

  end
end