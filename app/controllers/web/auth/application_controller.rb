class Web::Auth::ApplicationController < Web::ApplicationController
protected
  def auth_hash
    request.env['omniauth.auth']
  end
end