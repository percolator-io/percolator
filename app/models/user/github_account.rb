class User::GithubAccount < ActiveRecord::Base
  belongs_to :user

  serialize :auth_hash, OmniAuth::AuthHash

  validates :user, presence: true
  validates :uid, presence: true
  validates :auth_hash, presence: true
end
