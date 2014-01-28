require 'spec_helper'

describe Web::TagsController do
  before do
    @tag = create :tag
    @attrs = attributes_for :tag

    create :tag
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

    assert { response.status == 300 }

    tag = Tag.find_by_name @attrs[:name]
    assert tag
  end

  it 'get edit' do
    get :edit, id: @tag.id
    assert { response.status == 200 }
  end

  it 'update a tag' do
    put :update, id: @tag.id, tag: @attrs

    assert { response.status == 300 }
    @tag.reload
    assert_equal @attrs[:name], @tag.name
  end

  it 'destroy a tag' do
    delete :destroy, id: @tag.id

    assert { response.status == 300 }
    refute Tag.find_by_id(@tag.id)
  end
end