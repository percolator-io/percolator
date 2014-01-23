require 'spec_helper'

describe Api::V1::StarsController do
  before do
    @url = 'http://example.com/page.html'
    url_service = UrlService.from_string @url
    @id = url_service.calculate_id
  end

  describe "POST 'create'" do
    it "returns http success" do
      stub = stub_request(:get, @url).to_return(status: 200, body: "add real html")
      params = { url: @url }

      post :create, star: params

      assert { response.status == 200 }
      stub.should have_been_requested

      repository = HtmlDocumentSearchRepository.new
      repository.find!(@id)  #TODO: add exists? method
    end
  end
end
