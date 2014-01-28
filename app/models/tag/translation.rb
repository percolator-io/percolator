class Tag::Translation < ActiveRecord::Base
  belongs_to :tag

  validates :tag, presence: true
end
