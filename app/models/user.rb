class User < ActiveRecord::Base
  extend Enumerize
  include UserRepository

  has_many :category_selections, -> { includes(:category).order(:kind, 'categories.name') }

  validates :name, presence: true

  accepts_nested_attributes_for :category_selections, allow_destroy: true

  def guest?
    false
  end
end
