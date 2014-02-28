class Category < ActiveRecord::Base
  validates :name, presence: true
  acts_as_tree order: 'name'
end
