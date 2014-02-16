module WebAuthenticationHelper
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
    @current_user ||= User.find_by(id: session[:user_id]) || User::Guest.new
  end
end
