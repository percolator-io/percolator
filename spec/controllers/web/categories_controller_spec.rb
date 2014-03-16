require 'spec_helper'

describe Web::CategoriesController do
  before do
    @category = create :category
  end

  it 'get index' do
    get :index
    assert { response.status == 200 }
  end
end
