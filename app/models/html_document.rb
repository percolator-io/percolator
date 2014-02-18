class HtmlDocument
  class Star
    include Virtus.model

    attribute :user_id, Integer
    attribute :user, User
    attribute :created_at, DateTime
  end

  include Virtus.model

  attribute :id
  attribute :url
  attribute :host
  attribute :title
  attribute :description
  attribute :keywords, Array[String]
  attribute :categories, Array[Category]
  attribute :stars, Array[Star]
end
