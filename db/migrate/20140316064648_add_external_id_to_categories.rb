class AddExternalIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :external_id, :string
    add_index :categories, :external_id, unique: true
  end
end
