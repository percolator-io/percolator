class RemoveAvailableResourcesFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :available_resources
  end

  def down
    add_column :users, :available_resources, :string, array: true, default: []
  end
end
