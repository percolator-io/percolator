require 'spec_helper'

describe Web::CategoriesController do
  before do
    @category = create :category
    @attrs = attributes_for :category
  end

  it 'get index' do
    get :index
    assert { response.status == 200 }
  end

  it 'get new' do
    get :new
    assert { response.status == 200 }
  end

  it 'create a category' do
    post :create, category: @attrs

    assert { response.status == 302 }
    assert { Category.exists?(name: @attrs[:name]) == true  }
  end

  it 'get edit' do
    get :edit, id: @category.id
    assert { response.status == 200 }
  end

  it 'update a category' do
    put :update, id: @category.id, category: @attrs

    assert { response.status == 302 }
    @category.reload
    assert{ @category.name == @attrs[:name] }
  end

  it 'destroy a category' do
    delete :destroy, id: @category.id

    assert { response.status == 302 }
    assert { Category.exists?(@category.id) == false }
  end
end