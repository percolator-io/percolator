module UriNormalizer
  class << self
    def normalize(addressable_uri)
      addressable_uri.omit(:fragment).normalize
    end
  end
end
