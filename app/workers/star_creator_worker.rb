class StarCreatorWorker
  include Sidekiq::Worker

  def perform(uri_components)
    uri_components.symbolize_keys!
    uri = Addressable::URI.new uri_components

    response = Net::HTTP.get_response(uri.host, uri.request_uri, uri.port)

    attrs = {
        html: response.body
    }

    link = uri.to_s
    id = Digest::MD5.hexdigest link

    repository = HtmlDocumentSearchRepository.new
    repository.store id, attrs
  end
end