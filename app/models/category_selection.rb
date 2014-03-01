class CategorySelection < ActiveRecord::Base
  extend Enumerize

  belongs_to :category
  belongs_to :user

  validates :user, presence: true
  validates :category, presence: true
  validates :category_id, uniqueness: { scope: :user_id }
  validates :kind, presence: true

  enumerize :kind, in: { selected: 1, excluded: 2 }, default: :selected, scope: true
end
