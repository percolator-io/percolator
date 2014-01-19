class StarCreatorWorker
  include Sidekiq::Worker

  def perform(uri_components)
    uri_components.symbolize_keys!
    uri = Addressable::URI.new uri_components

    response = Net::HTTP.get_response(uri.host, uri.request_uri, uri.port)

    attrs = {
        html: response.body
    }

    repository = HtmlDocumentSearchRepository.new
    id = repository.id_from_url uri
    repository.store id, attrs
  end
end