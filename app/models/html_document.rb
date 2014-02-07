class HtmlDocument
  include Virtus.model

  attribute :id
  attribute :title
  attribute :description
  attribute :keywords, Array[String]
  attribute :categories, Array[Category]
  attribute :highlight, Array[String]

  attribute :url
  attribute :host
end