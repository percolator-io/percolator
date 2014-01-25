module IdGenerator
  class << self
    def from_normalized_uri(uri)
      Digest::MD5.hexdigest uri.to_s
    end
  end
end