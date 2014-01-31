class BaseSearchRepository
  POOL = ConnectionPool.new(size:  10, timeout: 3) { Elasticsearch::Client.new host: Figaro.env.elasticsearch_host }

  class << self
    def index(i = nil)
      return @index if i.nil?
      @index = i
    end

    def type(i = nil)
      return @type if i.nil?
      @type = i
    end

    def remove_all_documents
      POOL.with do |client|
        client.delete_by_query index: '_all', body: { query: { match_all: {} } }
      end
    end
  end
end