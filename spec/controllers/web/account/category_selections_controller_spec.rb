require 'spec_helper'

describe Web::Account::CategorySelectionsController do
  before do
    @user = create :user
    sign_in @user

    @category_selection = create :category_selection, user: @user
  end

  it 'get edit' do
    get :edit
    assert { response.status == 200 }
  end

  context 'update' do
    before do
      category1 = create :category
      category2 = create :category

      @attrs = [
          attributes_for(:category_selection, kind: :selected, category_id: category1.id),
          attributes_for(:category_selection, kind: :excluded, category_id: category2.id)
      ]
    end

    it 'normal' do
      put :update, user: { category_selections_attributes: @attrs }

      assert { response.status == 302 }
      assert{ @user.category_selections.count == 3 }
    end

    it 'fail' do
      @attrs << attributes_for(:category_selection, category_id: @category_selection.category_id)

      put :update, user: { category_selections_attributes: @attrs }

      assert { response.status == 200 }
    end

  end
end
