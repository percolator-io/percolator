module Elastic
  module HtmlDocument
    class AddStarCommand < Operation
      SCRIPT = <<-MVEL
        s = ctx._source;
        new_star = ["user_id" : user_id, "created_at" : star_created_at];
        stars = ($ in s.stars if $.user_id != user_id);
        stars.add(new_star);
        s.stars = stars;
      MVEL

      attr_reader :id, :user_id

      def initialize(id, user_id)
        @id = id
        @user_id = user_id
      end

      # options { refresh: true }
      def perform(options = {})
        star_created_at = DateTime.current
        script_params = { user_id: user_id, star_created_at: star_created_at }
        upsert = { stars: [ { user_id: user_id, created_at: star_created_at } ] }

        body = {
            script: SCRIPT,
            params: script_params,
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