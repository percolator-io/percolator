class HtmlDocumentSearchRepository < BaseSearchRepository
  self.index = :documents
  self.type = :html_document

  def search(q)
    return [] if q.blank?

    results = nil
    body = {
        query: { match: { _all: q } }
    }
    params = address.merge body: body

    POOL.with do |client|
      results = client.search params
    end

    results
  end

  def find!(id)
    result = nil
    params = address.merge id: id
    POOL.with do |client|
      result = client.get params
    end

    result
  end

  def store(id, attrs)
    params = address.merge id: id, body: attrs
    POOL.with do |client|
      client.index params
    end
  end


private
  def address
    { index: self.class.index, type: self.class.type }
  end
end