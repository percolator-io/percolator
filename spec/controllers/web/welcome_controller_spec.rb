require 'spec_helper'

describe Web::WelcomeController do

  describe "GET 'index'" do
    it "returns http success" do
      get :index

      assert { response.status == 200 }
    end
  end
end
