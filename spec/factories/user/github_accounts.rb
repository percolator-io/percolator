FactoryGirl.define do
  factory 'user/github_account' do
    uid
    auth_hash { generate :github_auth }
    user
  end
end
