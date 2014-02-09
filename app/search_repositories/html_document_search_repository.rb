class HtmlDocumentSearchRepository < BaseSearchRepository
  index :documents
  type :html_document

  FIELDS = %i(title description keywords url host)

  def search(q)
    return [] if q.blank?

    results = nil

    body = {
        query: { match: { _all: q } },
        highlight: {
          fields: { content: {} },
          pre_tags: ["<strong>"],
          post_tags: ["</strong>"],
        }
    }
    params = address.merge body: body, fields: FIELDS

    POOL.with do |client|
      results = client.search params
    end

    mash = Hashie::Mash.new results
    hits = mash.hits.hits

    models = hits.map{ |i| wrap_item i }
    ids = models.map &:id

    category_groups = mpercolate ids
    category_groups.each_with_index do |categories, index|
      m = models[index]
      m.categories = categories
    end

    models
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

  def mpercolate(ids)
    return [] if ids.empty?
    body = []
    ids.each do |id|
      body << { percolate: address.merge(id: id) }
      body << { }
    end

    responce = nil
    POOL.with do |client|
      responce = client.mpercolate body: body
    end

    # TODO: fix N+1
    responce['responses'].map do |resp|
      ids = resp.fetch('matches', []).map{ |m| m['_id'] }
      Category.find ids
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
        highlight: mash.highlight.try(:content),

        url: mash.fields.url.first,
        host: mash.fields.host.first,
    }

    HtmlDocument.new attrs
  end
end