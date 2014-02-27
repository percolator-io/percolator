module Elastic
  module DocumentsPercolator

    class DeleteCommand < Operation
      attr_reader :category

      def initialize(category)
        @category = category
      end

      def perform
        params = address.merge id: category.id
        POOL.with { |client| client.delete params }
      end
    end

  end
end