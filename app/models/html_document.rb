class HtmlDocument
  include Virtus.model

  attribute :id
  attribute :title
  attribute :description
  attribute :keywords, Array[String]

  attribute :url
  attribute :host
end