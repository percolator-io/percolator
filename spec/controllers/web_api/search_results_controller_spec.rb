require 'spec_helper'

describe WebApi::SearchResultsController do

  describe "GET 'index'" do
    before do
      url = 'http://example.com/page1'

      attrs = generate :page_attrs
      attrs.merge! url: url, host: 'example.com'

      id = IdGenerator.from_normalized_uri url
      repository = HtmlDocumentSearchRepository.new
      user = create :user
      repository.store id, attrs, user.id

      sleep 1 #ждем индексацию эластика, может быть есть опция конфига
    end

    it "returns http success" do
      get :index, format: :json, q: 'html'
      assert { response.status == 200 }
    end
  end
end
