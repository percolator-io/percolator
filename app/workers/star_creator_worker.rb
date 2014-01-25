class StarCreatorWorker
  include Sidekiq::Worker

  def perform(normalized_uri_components)
    normalized_uri_components.symbolize_keys!
    uri = Addressable::URI.new normalized_uri_components

    response = Net::HTTP.get(uri)

    attrs = {
        url: uri.to_s,
        host: uri.host,
        html: response,
    }

    id = IdGenerator.from_normalized_uri uri
    repository = HtmlDocumentSearchRepository.new
    repository.store id, attrs
  end
end