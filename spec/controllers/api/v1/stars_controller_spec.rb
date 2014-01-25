require 'spec_helper'

describe Api::V1::StarsController do
  before do
    @url = 'http://example.com/page.html'
    @id = IdGenerator.from_normalized_uri @url

    @page_attrs = generate :page_attrs
    @page = HtmlPage.render @page_attrs
  end

  describe "POST 'create'" do
    it "returns http success" do
      stub = stub_request(:get, @url).to_return(status: 200, body: @page)
      params = { url: @url }

      post :create, star: params

      assert { response.status == 200 }
      stub.should have_been_requested

      repository = HtmlDocumentSearchRepository.new
      document = repository.find! @id

      assert { document.id == @id }
      assert { document.host == 'example.com' }
      assert { document.url == @url }
      assert { document.title == @page_attrs[:title] }
      assert { document.description == @page_attrs[:description] }
      assert { document.keywords.join(',') == @page_attrs[:keywords] }
    end
  end
end
