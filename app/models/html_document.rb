class HtmlDocument
  class Star
    include Virtus.model

    attribute :user_id
    attribute :created_at
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
