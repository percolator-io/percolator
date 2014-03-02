class Category < ActiveRecord::Base
  validates :name, presence: true
  acts_as_tree order: 'name'
  has_paper_trail
end
