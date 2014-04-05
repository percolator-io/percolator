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

  attributes :id, :url, :host, :title, :description, :keywords

  has_many :categories, serializer: CategorySerializer
  has_many :stars, serializer: StarSerializer
end
