module Elastic
  module HtmlDocument
    class WideSearchQuery < BaseQuery
      attr_accessor :phrase

      def initialize(phrase)
        @phrase = phrase
      end

      def result
       q = phrase.present? ? query : match_all
        search q
      end

    private
      def match_all
        {
            query: {
                match_all: {}
            }
        }
      end

      def query
        { query: { match: { _all: phrase } } }
      end
    end
  end
end
