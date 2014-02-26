require 'spec_helper'

describe Api::V1::StarsController do
  before do
    @url = 'http://example.com/page.html'
    @id = IdGenerator.from_normalized_uri @url

    @page_attrs = generate :page_attrs
    @page = HtmlPage.render @page_attrs
    @stub = stub_request(:get, @url).to_return(status: 200, body: @page, headers: { "Content-Type" => 'text/html' })

    @user = create :user
    access_token = create :access_token, resource_owner_id: @user.id
    @params = { star: { url: @url }, access_token: access_token.token }
  end

  describe "POST 'create'" do
    it "returns http success" do
      post :create, @params

      assert { response.status == 200 }
      @stub.should have_been_requested

      document = Elastic::HtmlDocument::FindQuery.new(@id).result

      assert { document.id == @id }
      assert { document.host == 'example.com' }
      assert { document.url == @url }
      assert { document.title == @page_attrs[:title] }
      assert { document.description == @page_attrs[:description] }
      assert { document.keywords.join(',') == @page_attrs[:keywords] }
      assert { document.stars.length == 1 }
      assert { document.stars.first.user_id == @user.id }
    end
  end
end
