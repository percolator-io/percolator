FactoryGirl.define do
  factory 'doorkeeper/application' do
    name
    redirect_uri 'https://app.me/'
  end

  factory 'doorkeeper/access_token', aliases: [:access_token] do
    association :application, factory: 'doorkeeper/application'
    resource_owner_id { create(:user).id }
  end
end
