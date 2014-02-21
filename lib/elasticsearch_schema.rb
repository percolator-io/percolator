module ElasticsearchSchema
  # TODO: подумать над рефакторингом

  class << self
    def create_indices
      BaseSearchRepository::POOL.with do |client|
        client.indices.create index: :documents, body: { settings: ElasticsearchSchema::DocumentsIndex.settings }
      end
    end

    def remove_indicies
      BaseSearchRepository::POOL.with do |client|
        client.indices.delete index: '_all'
      end
    end

    def put_mappings
      BaseSearchRepository::POOL.with do |client|
        ElasticsearchSchema::DocumentsIndex.mappings.each do |type, mapping|
          client.indices.put_mapping index: :documents, type: type, body: { type => mapping }, ignore_conflicts: true
        end
      end
    end

    def put_settings
      BaseSearchRepository::POOL.with do |client|
        client.indices.close index: :documents
        client.indices.put_settings index: :documents, body: ElasticsearchSchema::DocumentsIndex.settings
        client.indices.open index: :documents
      end
    end
  end
end