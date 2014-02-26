module Elastic

  module Indices
    class << self
      def create
        POOL.with do |client|
          client.indices.create index: :documents, body: { settings: self::Documents.settings }
        end
      end

      def remove
        POOL.with do |client|
          client.indices.delete index: '_all'
        end
      end

      def put_mappings
        POOL.with do |client|
          self::Documents.mappings.each do |type, mapping|
            client.indices.put_mapping index: :documents, type: type, body: { type => mapping }
          end
        end
      end

      def clean
        POOL.with do |client|
          client.delete_by_query index: '_all', body: { query: { match_all: {} } }
        end
      end
    end
  end

end