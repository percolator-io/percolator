require 'spec_helper'

describe WebApi::HtmlDocumentsController do

  describe "GET 'index'" do
    before do
      url = 'http://example.com/page1'

      attrs = generate :page_attrs
      attrs.merge! url: url, host: 'example.com'

      id = IdGenerator.from_normalized_uri url
      Elastic::HtmlDocument::UpdateCommand.new(id, attrs).perform(refresh: true)
    end

    it "returns http success" do
      get :index, format: :json, q: 'lorem ipsum'
      assert { response.status == 200 }

      json = JSON.parse(response.body)
      assert { json['html_documents'].one? == true }
      assert { json['meta'].any? == true }
    end
  end
end
