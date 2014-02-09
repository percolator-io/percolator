require 'spec_helper'

describe Web::Auth::GithubController do
  before do
    auth = generate :github_auth
    request.env['omniauth.auth'] = auth

    @uid = auth.uid
    @name = auth.info.name
  end

  it 'create new user' do
    get :callback
    assert { response.status == 302 }
    user = User.find_by name: @name

    assert { user }
    assert { signed_in?(user) == true }
  end

  it 'should sign in user' do
    account = create 'user/github_account', uid: @uid
    get :callback

    assert { response.status == 302 }
    assert { signed_in?(account.user) == true }
  end
end
