class StarCreatorService
  class BaseError < StandardError; end
  class BlankUrlError < BaseError; end

  attr_reader :url

  def initialize(url)
    raise BlankUrlError if url.blank?

    @url = url
  end

  def create
    StarCreatorWorker.perform_async uri_components
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