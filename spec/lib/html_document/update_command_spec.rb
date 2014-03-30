require 'spec_helper'

describe Elastic::HtmlDocument::UpdateCommand do
  before do
    @url = 'http://example.com/page.html'
    @id = IdGenerator.from_normalized_uri @url
  end

  it 'add second star and update' do
    first_page_attrs = generate :page_attrs
    first_page_attrs.merge! url: @url, host: 'example.com'
    Elastic::HtmlDocument::UpdateCommand.new(@id, first_page_attrs).perform

    second_page_attrs = generate :page_attrs
    second_page_attrs.merge! url: @url, host: 'example.com'
    Elastic::HtmlDocument::UpdateCommand.new(@id, second_page_attrs).perform

    document = Elastic::HtmlDocument::FindQuery.new(@id).result

    assert { document.title == second_page_attrs[:title] }
  end
end
