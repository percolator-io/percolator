require 'spec_helper'

describe WebApi::SearchResultsController do

  describe "GET 'index'" do
    before do
      url = 'http://example.com/page1'
      attrs = {
          url: url,
          host: 'example.com',
          html: 'some html',
      }

      id = IdGenerator.from_normalized_uri url
      repository = HtmlDocumentSearchRepository.new
      repository.store id, attrs

      sleep 1 #ждем индексацию эластика, может быть есть опция конфига
    end

    it "returns http success" do
      get :index, format: :json, q: 'html'
      assert { response.status == 200 }
    end
  end
end
