require 'spec_helper'

describe Api::V1::StarsController do

  describe "POST 'create'" do
    it "returns http success" do
      post 'create'
      assert { response.status == 200 }
    end
  end
end
