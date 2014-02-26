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
        phrases = [category.name] | category.keywords
        queries = phrases.map do |phrase|
          {
              multi_match: {
                  query: phrase,
                  type: 'phrase',
                  fields: %w(title description keywords host)
              }
          }
        end
        {
            query: {
                bool: {
                    should: queries
                }
            }
        }
      end
    end

  end
end