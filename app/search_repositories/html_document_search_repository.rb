class HtmlDocumentSearchRepository < BaseSearchRepository
  index :documents
  type :html_document

  FIELDS = %i(title description keywords url host stars)

  def search(q)
    return [] if q.blank?

    results = nil

    body = {
        _source: FIELDS,
        query: { match: { _all: q } }
    }
    params = address.merge body: body

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
    params = address.merge id: id, _source: FIELDS
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

  def store(id, attrs, user_id)
    star_created_at = DateTime.current
    upsert = attrs.merge stars: [ { user_id: user_id, created_at: star_created_at } ]

    s_params = { user_id: user_id, star_created_at: star_created_at, attrs: attrs }
    script = <<-MVEL
      s = ctx._source;
      foreach (attr : attrs.entrySet())
      {
        s[attr.key] = attr.value;
      }
      new_star = ["user_id" : user_id, "created_at" : star_created_at];
      stars = ($ in s.stars if $.user_id != user_id);
      stars.add(new_star);
      s.stars = stars;
    MVEL

    body = {
        script: script,
        params: s_params,
        upsert: upsert,
    }
    params = address.merge id: id, body: body

    POOL.with do |client|
      client.update params
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
    attrs = mash._source
    attrs.id = mash._id
    HtmlDocument.new attrs
  end
end