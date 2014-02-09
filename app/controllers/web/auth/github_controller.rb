class Web::Auth::GithubController < Web::Auth::ApplicationController
  def callback
    account = User::GithubAccount.find_or_initialize_by uid: auth_hash.uid
    account.auth_hash = auth_hash
    account.user ||= User.create! name: auth_hash.info.name
    account.save!

    sign_in account.user

    redirect_to root_path
  end
end
