class StarCreatorWorker
  include Sidekiq::Worker

  # TODO: fix port
  ELASTIC_POOL = ConnectionPool.new(size:  10, timeout: 3) { Elasticsearch::Client.new host: 'localhost:9201' }

  def perform(uri_components)
    uri_components.symbolize_keys!
    uri = Addressable::URI.new uri_components

    response = Net::HTTP.get_response(uri.host, uri.request_uri, uri.port)

    link = uri.to_s
    id = Digest::MD5.hexdigest link

    ELASTIC_POOL.with do |elastic|
      elastic.index  index: 'documents', type: 'html', id: id, body: { html: response.body }
    end
  end
end