require 'spec_helper'

describe Elastic::HtmlDocument::AddStarCommand do
  before do
    @url = 'http://example.com/page.html'
    @id = IdGenerator.from_normalized_uri @url
  end

  it 'add second star and update' do
    first_user = create :user
    Elastic::HtmlDocument::AddStarCommand.new(@id, first_user.id).perform

    second_user = create :user
    Elastic::HtmlDocument::AddStarCommand.new(@id, second_user.id).perform

    document = Elastic::HtmlDocument::FindQuery.new(@id).result
    stars = document.stars

    assert { stars.length == 2 }
    assert { stars.first.user_id == first_user.id }
    assert { stars.second.user_id == second_user.id }
  end
end
