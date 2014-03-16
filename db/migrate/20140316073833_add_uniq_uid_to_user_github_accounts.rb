class AddUniqUidToUserGithubAccounts < ActiveRecord::Migration
  def up
    remove_index :user_github_accounts, :uid
    add_index :user_github_accounts, :uid, unique: true
  end

  def down
    remove_index :user_github_accounts, :uid
    add_index :user_github_accounts, :uid
  end
end
