module Elastic
  module HtmlDocument
    class UpdateCommand < Operation
      attr_reader :id, :attributes

      def initialize(id, attributes)
        @id = id
        @attributes = attributes
      end

      # options { refresh: true }
      def perform(options = {})
        body = {
            doc: attributes,
            doc_as_upsert: true,
        }

        params = address.merge id: id, body: body
        params.merge! options

        POOL.with do |client|
          client.update params
        end
      end
    end

  end
end