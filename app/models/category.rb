class Category < ActiveRecord::Base
  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true
  acts_as_tree order: 'name'
end
