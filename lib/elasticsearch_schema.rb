module ElasticsearchSchema
  class << self
    def create_indices
      BaseSearchRepository::POOL.with do |client|
        client.indices.create index: :documents
      end
    end

    def put_mappings
      BaseSearchRepository::POOL.with do |client|
        ElasticsearchSchema::DocumentsIndex.mappings.each do |type, mapping|
          client.indices.put_mapping index: :documents, type: type, body: { type => mapping }
        end
      end
    end
  end
end