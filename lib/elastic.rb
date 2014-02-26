module Elastic
  POOL = ConnectionPool.new(size:  10, timeout: 3) do
    Elasticsearch::Client.new host: Figaro.env.elasticsearch_host
  end
end