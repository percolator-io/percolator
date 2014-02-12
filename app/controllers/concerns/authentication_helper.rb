module AuthenticationHelper
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?, :signed_out?
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def signed_in?
    !current_user.guest?
  end

  def signed_out?
    !signed_in?
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) || User::Guest.new
  end

  def authenticate_user!
    redirect_to root_path unless signed_in?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |user, password|
      user == configus.basic_auth.username && password == configus.basic_auth.password
    end
  end
end
