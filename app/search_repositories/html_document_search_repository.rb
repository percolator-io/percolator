class HtmlDocumentSearchRepository < BaseSearchRepository
  self.index = :documents
  self.type = :html_document

  def search(q)
    return [] if q.blank?

    results = nil
    POOL.with do |client|
      body = {
        query: { match: { _all: q } }
      }
      results = client.search index: self.class.index, type: self.class.type, body: body
    end

    results
  end




  def store(id, attrs)
    POOL.with do |client|
      client.index  index: self.class.index, type: self.class.type, id: id, body: attrs
    end
  end
end