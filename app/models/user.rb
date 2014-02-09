class User < ActiveRecord::Base
  validates :name, presence: true

  def guest?
    false
  end
end
