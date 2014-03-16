require 'spec_helper'

describe Private::CategoriesDeploysController do
  context 'normal' do
    before do
      @params = { secret: Figaro.env.github_webhook_secret }

      url = "https://raw.github.com/percolator-io/categories/master/data/categories.yml"
      path = fixture_file_path('categories.yml')
      body = File.read(path)
      @stub = stub_request(:get, url).to_return(status: 200, body: body)
      @existing_category = create :category, external_id: 'existing_category'
    end

    it 'deploy categories' do
      post :create, @params

      assert { response.status == 200 }
      @stub.should have_been_requested
      assert { Category.count == 4 }
      assert { Category.exists?(external_id: 'category') == true }
      assert { Category.exists?(external_id: 'with_subcategories') == true }
      assert { Category.exists?(external_id: 'sub') == true }

      @existing_category.reload
      assert { @existing_category.name == 'existing' }
      assert { @existing_category.query == 'existing query' }
    end
  end

  context "wrong" do
    before do
      @params = { secret: 'invalid' }
    end

    it 'deploy categories' do
      post :create, @params

      assert { response.status == 403 }
      assert { Category.count == 0 }
    end
  end
end
