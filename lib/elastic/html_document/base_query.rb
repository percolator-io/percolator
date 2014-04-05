module Elastic
  module HtmlDocument

    class BaseQuery < Operation
      FIELDS = %i(title description keywords url host stars content_in_base64)

    private
      def search(q)
        body = { _source: FIELDS }
        body.merge! q
        params = address.merge body: body

        results = POOL.with { |client| client.search params }

        mash = Hashie::Mash.new results
        models = mash.hits.hits.map{ |i| wrap_item i }
        add_categories! models
        add_users_to_stars! models

        Collection.new models, mash.hits.total
      end

      def wrap_item(mash)
        attrs = mash._source
        attrs.id = mash._id
        ::HtmlDocument.new attrs
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

        responce = POOL.with do |client|
          client.mpercolate body: body
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

  end
end
