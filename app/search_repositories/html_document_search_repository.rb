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
    params = address.merge id: id, fields: %i(url host)
    POOL.with do |client|
      result = client.get params
    end

    wrap_item result
  end

  def exists(id)
    POOL.with do |client|
      client.exists address.merge id: id
    end
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

  def wrap_item(params)
    mash = Hashie::Mash.new params

    attrs = {
        id: mash._id,
        url: mash.fields.url.first,
        host: mash.fields.host.first,
    }

    HtmlDocument.new attrs
  end
end