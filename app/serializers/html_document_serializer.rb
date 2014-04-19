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

  extend MethodDecorators

  attributes :id, :url, :host, :title, :description, :keywords

  has_many :categories, serializer: CategorySerializer
  has_many :stars, serializer: StarSerializer

  def title
    sanitizer.sanitize object.title, tags: %w[em]
  end

  def description
    sanitizer.sanitize object.description, tags: %w[em]
  end

  +MethodDecorators::Memoize
  def sanitizer
    HTML::WhiteListSanitizer.new
  end
end
