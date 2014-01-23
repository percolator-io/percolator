class StarCreatorService
  class BaseError < StandardError; end
  class BlankUrlError < BaseError; end

  attr_reader :url

  def initialize(url)
    raise BlankUrlError if url.blank?

    @url = url
  end

  def create
    url_service = UrlService.from_string url
    uri_components = url_service.uri.to_hash
    id = url_service.calculate_id

    StarCreatorWorker.perform_async id, uri_components
  end

  private
  def uri_components
    #TODO: wrap Addressable errors

    uri = Addressable::URI.parse url
    uri.normalize!

    components = uri.to_hash
    components.delete :fragment
    components
  end
end