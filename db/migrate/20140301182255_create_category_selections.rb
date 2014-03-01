class CreateCategorySelections < ActiveRecord::Migration
  def change
    create_table :category_selections do |t|
      t.references :category, index: true
      t.references :user, index: true
      t.integer :kind

      t.timestamps
    end

    add_index :category_selections, %i(user_id category_id), unique: true
  end
end
