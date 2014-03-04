require 'spec_helper'

describe Web::SessionsController do
  before do
    user = create :user
    sign_in user
  end

  it 'delete' do
    delete :destroy

    assert{ session[:user_id].nil? }
  end
end
