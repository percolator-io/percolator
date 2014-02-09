class CreateUserGithubAccounts < ActiveRecord::Migration
  def change
    create_table :user_github_accounts do |t|
      t.references :user, index: true
      t.string :uid
      t.text :auth_hash

      t.timestamps
    end
    add_index :user_github_accounts, :uid
  end
end
