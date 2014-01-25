class StarCreatorService
  class BaseError < StandardError; end
  class BlankUrlError < BaseError; end

  attr_reader :url

  def initialize(url)
    raise BlankUrlError if url.blank?

    @url = url
  end

  def create
    uri = Addressable::URI.parse url
    normalized_uri = UriNormalizer.normalize uri
    components = normalized_uri.to_hash

    StarCreatorWorker.perform_async components
  end
end