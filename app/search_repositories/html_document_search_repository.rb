class HtmlDocumentSearchRepository < BaseSearchRepository
  self.index = :documents
  self.type = :html_document

  def store(id, attrs)
    POOL.with do |client|
      client.index  index: self.class.index, type: self.class.type, id: id, body: attrs
    end
  end

  def id_from_url(url)
    Digest::MD5.hexdigest url.to_s
  end
end