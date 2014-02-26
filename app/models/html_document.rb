class HtmlDocument
  class Star
    include Elastic::ModelMixin

    attribute :user_id, Integer
    attribute :user, User
    attribute :created_at, DateTime
  end

  include Elastic::ModelMixin

  attribute :id
  attribute :url
  attribute :host
  attribute :title
  attribute :description
  attribute :keywords, Array[String]
  attribute :categories, Array[Category]
  attribute :stars, Array[Star]

end
