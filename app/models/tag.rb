class Tag < ActiveRecord::Base
  has_many :translations, dependent: :destroy, inverce_of: :tag

  acts_as_tree
end
