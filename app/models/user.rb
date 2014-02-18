class User < ActiveRecord::Base
  validates :name, presence: true

  after_initialize :set_api_token, if: :new_record?

  def guest?
    false
  end

private
  def set_api_token
    self.api_token = SecureHelper.generate_token
  end
end
