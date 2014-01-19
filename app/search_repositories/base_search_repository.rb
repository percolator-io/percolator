class BaseSearchRepository
  # TODO: fix port
  POOL = ConnectionPool.new(size:  10, timeout: 3) { Elasticsearch::Client.new host: 'localhost:9201' }

  cattr_accessor :index, :type


  class << self
    def remove_all_documents
      POOL.with do |client|
        client.delete_by_query index: '_all', body: { query: { match_all: {} } }
      end
    end

    def remove_all_indicies
      POOL.with do |client|
        client.indices.delete index: '_all'
      end
    end
  end
end