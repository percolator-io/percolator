class HtmlDocumentSearchRepository < BaseSearchRepository
  index :documents
  type :html_document

  FIELDS = %i(title description keywords url host stars)

  def search(q)
    return [] if q.blank?

    results = nil

    body = {
        _source: FIELDS,
        #TODO: use multi_match
        query: { match: { _all: q } }
    }
    params = address.merge body: body

    POOL.with do |client|
      results = client.search params
    end

    mash = Hashie::Mash.new results
    hits = mash.hits.hits

    models = hits.map{ |i| wrap_item i }
    add_categories! models
    add_users_to_stars! models

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

private
  def address
    { index: self.class.index, type: self.class.type }
  end

  def wrap_item(mash)
    attrs = mash._source
    attrs.id = mash._id
    HtmlDocument.new attrs
  end

  def add_categories!(models)
    ids = models.map &:id
    category_ids_groups = mpercolate ids
    category_ids = category_ids_groups.inject(Set.new) do |set, category_ids|
      set.merge category_ids
    end

    categories = Category.find category_ids.to_a
    categories_hash = categories.inject({}){ |hash, c| hash.merge c.id => c }

    category_ids_groups.each_with_index do |category_ids, index|
      current_categories = category_ids.map{ |id| categories_hash[id] }
      models[index].categories = current_categories
    end
  end

  def mpercolate(documents_ids)
    return [] if documents_ids.empty?
    body = []
    documents_ids.each do |id|
      body << { percolate: address.merge(id: id) }
      body << { }
    end

    responce = nil
    POOL.with do |client|
      responce = client.mpercolate body: body
    end

    responce['responses'].map do |resp|
      resp.fetch('matches', []).map do |m|
        m['_id'].to_i
      end
    end
  end

  def add_users_to_stars!(models)
    ids = models.inject(Set.new) do |set, document|
      user_ids = document.stars.map &:user_id
      set.merge user_ids
    end
    users = User.find ids.to_a
    users_map = users.inject({}){ |hash, user| hash.merge user.id => user }

    models.each do |document|
      document.stars.each do |star|
        star.user = users_map[star.user_id]
      end
    end
  end
end
