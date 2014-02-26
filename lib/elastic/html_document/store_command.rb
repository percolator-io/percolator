module Elastic
  module HtmlDocument

    # TODO: split to StarCommand and UpdateCommand
    class StoreCommand < Operation
      SCRIPT = <<-MVEL
        s = ctx._source;
        foreach (attr : attributes.entrySet())
        {
          s[attr.key] = attr.value;
        }
        new_star = ["user_id" : user_id, "created_at" : star_created_at];
        stars = ($ in s.stars if $.user_id != user_id);
        stars.add(new_star);
        s.stars = stars;
      MVEL

      attr_reader :id, :attributes, :user_id

      def initialize(id, attributes, user_id)
        @id = id
        @attributes = attributes
        @user_id = user_id
      end

      # options { refresh: true }
      def perform(options = {})
        star_created_at = DateTime.current
        upsert = attributes.merge stars: [ { user_id: user_id, created_at: star_created_at } ]

        s_params = { user_id: user_id, star_created_at: star_created_at, attributes: attributes }

        body = {
            script: SCRIPT,
            params: s_params,
            upsert: upsert,
        }

        params = address.merge id: id, body: body
        params.merge! options

        POOL.with do |client|
          client.update params
        end
      end
    end

  end
end