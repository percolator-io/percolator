module ApiAuthenticationHelper
  extend ActiveSupport::Concern

  def signed_in?
    !current_user.guest?
  end

  def current_user
    @current_user ||= User.find_by(api_token: params[:access_token]) || User::Guest.new
  end
end
