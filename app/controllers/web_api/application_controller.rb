class WebApi::ApplicationController < ApplicationController
  include WebAuthenticationHelper
  respond_to :json
  layout false

  #before_filter :authenticate_user!

private
  #def authenticate_user!
  #  false unless signed_in?
  #end
end
