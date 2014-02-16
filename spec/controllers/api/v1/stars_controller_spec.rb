require 'spec_helper'

describe Api::V1::StarsController do
  before do
    @url = 'http://example.com/page.html'
    @id = IdGenerator.from_normalized_uri @url

    @page_attrs = generate :page_attrs
    @page = HtmlPage.render @page_attrs
    @user = create :user
    @stub = stub_request(:get, @url).to_return(status: 200, body: @page, headers: { "Content-Type" => 'text/html' })
    @params = { star: { url: @url }, access_token: @user.api_token }
    @repository = HtmlDocumentSearchRepository.new
  end

  describe "POST 'create'" do
    it "returns http success" do
      post :create, @params

      assert { response.status == 200 }
      @stub.should have_been_requested

      document = @repository.find! @id

      assert { document.id == @id }
      assert { document.host == 'example.com' }
      assert { document.url == @url }
      assert { document.title == @page_attrs[:title] }
      assert { document.description == @page_attrs[:description] }
      assert { document.keywords.join(',') == @page_attrs[:keywords] }
      assert { document.stars.length == 1 }
      assert { document.stars.first.user_id == @user.id }
    end

    # похоже на интеграционный тест
    it 'add second star and update' do
      first_user = create :user
      first_page_attrs = generate :page_attrs
      first_page_attrs.merge! url: @url, host: 'example.com'
      @repository.store @id, first_page_attrs, first_user.id

      post :create, @params
      @stub.should have_been_requested

      document = @repository.find! @id
      stars = document.stars

      assert { document.title == @page_attrs[:title] }
      assert { stars.length == 2 }
      assert { stars.first.user_id == first_user.id }
      assert { stars.second.user_id == @user.id }
    end
  end
end
