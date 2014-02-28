class AddQueryToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :query, :text, default: ''
  end
end
