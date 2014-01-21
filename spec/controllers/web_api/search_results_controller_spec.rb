require 'spec_helper'

describe WebApi::SearchResultsController do

  describe "GET 'index'" do
    before do
    end

    it "returns http success" do
      get :index, format: :json, q: 'phrase'

      assert { response.status == 200 }
    end
  end
end
