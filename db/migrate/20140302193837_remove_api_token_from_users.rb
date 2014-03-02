class RemoveApiTokenFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :api_token
  end

  def down
    add_column :users, :api_token, :string
  end
end
