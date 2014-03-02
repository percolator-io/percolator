class AddAvailableResourcesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :available_resources, :string, array: true, default: []
  end
end
