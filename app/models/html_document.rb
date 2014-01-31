class HtmlDocument
  include Virtus.model

  attribute :id
  attribute :title
  attribute :description
  attribute :keywords, Array[String]
  attribute :tags, Array[Tag]

  attribute :url
  attribute :host
end