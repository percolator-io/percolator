class Web::ApplicationController < ApplicationController
  include WebAuthenticationHelper

  protect_from_forgery with: :exception

  #before_filter :authenticate_user!
private
  #def authenticate_user!
  #  redirect_to root_path unless signed_in?
  #end
end
