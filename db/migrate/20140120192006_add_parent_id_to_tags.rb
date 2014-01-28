class AddParentIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :parent_id, :integer
  end
end
