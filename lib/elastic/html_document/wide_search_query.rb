module Elastic
  module HtmlDocument
    class WideSearchQuery < BaseQuery
      attr_accessor :phrase

      def initialize(phrase)
        @phrase = phrase
      end

      def result
        q = {
            query: { match: { _all: phrase } }
        }

        search q
      end
    end
  end
end
