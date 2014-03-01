class User < ActiveRecord::Base
  include UserRepository
  has_many :category_selections

  validates :name, presence: true
  after_initialize :set_api_token, if: :new_record?
  accepts_nested_attributes_for :category_selections, allow_destroy: true

  def guest?
    false
  end

private
  def set_api_token
    self.api_token = SecureHelper.generate_token
  end
end
