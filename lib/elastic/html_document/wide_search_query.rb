module Elastic
  module HtmlDocument
    class WideSearchQuery < BaseQuery
      attr_reader :query_string, :offset

      def initialize(query_string, offset = nil)
        @query_string = query_string
        @offset = offset || 0
      end

      def result
        q = query_string.present? ? query : match_all
        search q
      end

    private
      def match_all
        {
            from: offset,
            query: { match_all: {} }
        }
      end

      def query
        {
          from: offset,
          query: {
            simple_query_string: {
              query: query_string,
              fields: %w(title^2 description keywords content host),
            }
          }
        }
      end
    end
  end
end
