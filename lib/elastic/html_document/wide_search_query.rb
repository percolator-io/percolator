module Elastic
  module HtmlDocument
    class WideSearchQuery < BaseQuery
      attr_accessor :phrase, :offset

      def initialize(phrase, offset = nil)
        @phrase = phrase
        @offset = offset || 0
      end

      def result
       q = phrase.present? ? query : match_all
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
            query: { match: { _all: phrase } }
        }
      end
    end
  end
end
