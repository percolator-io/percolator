class HtmlDocumentSerializer < ActiveModel::Serializer
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class StarSerializer < ActiveModel::Serializer
    attributes :created_at
    has_one :user, serializer: UserSerializer
  end

  class CategorySerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  attributes :id, :url, :host, :title, :description, :keywords, :content

  has_many :categories, serializer: CategorySerializer
  has_many :stars, serializer: StarSerializer


  def content
    html = Base64.decode64(object.content_in_base64)

    #img, a
    tags = ["section", "article", "strong", "em", "b", "i", "p", "code", "pre", "tt", "samp", "kbd", "var", "sub", "sup", "dfn", "cite", "big", "small", "address", "hr", "br", "div", "span", "h1", "h2", "h3", "h4", "h5", "h6", "ul", "ol", "li", "dl", "dt", "dd", "abbr", "acronym", "blockquote", "del", "ins"]
    Readability::Document.new(html, tags: tags).content
  end
end
