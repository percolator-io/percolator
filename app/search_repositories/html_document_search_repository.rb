class HtmlDocumentSearchRepository < BaseSearchRepository
  self.index = :documents
  self.type = :html_document

  FIELDS = %i(title description keywords url host)

  def search(q)
    return [] if q.blank?

    results = nil
    body = {
        query: { match: { _all: q } }
    }
    params = address.merge body: body, fields: FIELDS

    POOL.with do |client|
      results = client.search params
    end

    mash = Hashie::Mash.new results
    mash.hits.hits.map{ |i| wrap_item i }
  end

  def find!(id)
    result = nil
    params = address.merge id: id, fields: FIELDS
    POOL.with do |client|
      result = client.get params
    end

    mash = Hashie::Mash.new result
    wrap_item mash
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

  def wrap_item(mash)
    attrs = {
        id: mash._id,
        title: mash.fields.title.try(:first),
        description: mash.fields.description.try(:first),
        keywords: mash.fields.keywords,

        url: mash.fields.url.first,
        host: mash.fields.host.first,
    }

    HtmlDocument.new attrs
  end
end