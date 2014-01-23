class UrlService
  attr_reader :uri

  class << self
    def from_string(link)
      uri = Addressable::URI.parse link
      new(uri)
    end
  end

  def initialize(addressable_uri)
    @uri = addressable_uri.omit(:fragment).normalize
  end

  def calculate_id
    Digest::MD5.hexdigest uri.to_s
  end
end