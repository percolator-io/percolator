require 'spec_helper'

describe Elastic::HtmlDocument::StoreCommand do
  before do
    @url = 'http://example.com/page.html'
    @id = IdGenerator.from_normalized_uri @url
  end

  it 'add second star and update' do
    first_user = create :user
    first_page_attrs = generate :page_attrs
    first_page_attrs.merge! url: @url, host: 'example.com'
    Elastic::HtmlDocument::StoreCommand.new(@id, first_page_attrs, first_user.id).perform

    second_user = create :user
    second_page_attrs = generate :page_attrs
    second_page_attrs.merge! url: @url, host: 'example.com'
    Elastic::HtmlDocument::StoreCommand.new(@id, second_page_attrs, second_user.id).perform

    document = Elastic::HtmlDocument::FindQuery.new(@id).result
    stars = document.stars

    assert { document.title == second_page_attrs[:title] }
    assert { stars.length == 2 }
    assert { stars.first.user_id == first_user.id }
    assert { stars.second.user_id == second_user.id }
  end
end
