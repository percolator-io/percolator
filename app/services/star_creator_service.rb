module StarCreatorService
  class BaseError < StandardError; end
  class BlankUrlError < BaseError; end

  class << self
    def create(url, user)
      raise BlankUrlError if url.blank?

      uri = Addressable::URI.parse url
      normalized_uri = UriNormalizer.normalize uri
      components = normalized_uri.to_hash

      StarCreatorWorker.perform_async components, user.id
    end
  end

end