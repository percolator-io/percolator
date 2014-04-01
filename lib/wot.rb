class Wot
  include HTTParty
  attr_reader :api_key

  base_uri 'api.mywot.com'
  parser -> (body, _) { JSON.parse(body) }

  def initialize(api_key)
    @api_key = api_key
  end

  def reputation(host)
    options = {
        query: {
          hosts: "#{host}/",
          key: api_key,
        }
    }

    self.class.get("/0.4/public_link_json2/", options)
  end
end
