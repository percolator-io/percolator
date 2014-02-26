module Elastic
  module HtmlDocument
    class FindQuery < BaseQuery
      attr_accessor :id

      def initialize(id)
        @id = id
      end

      def result
        params = address.merge id: id, _source: FIELDS
        result = POOL.with { |client| client.get params }

        mash = Hashie::Mash.new result
        wrap_item mash
      end
    end
  end
end
