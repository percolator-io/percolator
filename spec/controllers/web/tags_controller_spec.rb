require 'spec_helper'

describe Web::TagsController do
  before do
    @tag = create :tag
    @attrs = attributes_for :tag
  end

  it 'get index' do
    get :index
    assert { response.status == 200 }
  end

  it 'get new' do
    get :new
    assert { response.status == 200 }
  end

  it 'create a tag' do
    post :create, tag: @attrs

    assert { response.status == 302 }
    assert { Tag.exists?(name: @attrs[:name]) == true  }
  end

  it 'get edit' do
    get :edit, id: @tag.id
    assert { response.status == 200 }
  end

  it 'update a tag' do
    put :update, id: @tag.id, tag: @attrs

    assert { response.status == 302 }
    @tag.reload
    assert{ @tag.name == @attrs[:name] }
  end

  it 'destroy a tag' do
    delete :destroy, id: @tag.id

    assert { response.status == 302 }
    assert { Tag.exists?(@tag.id) == false }
  end
end