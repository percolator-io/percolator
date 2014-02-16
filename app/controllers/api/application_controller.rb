class Api::ApplicationController < ApplicationController
  include ApiAuthenticationHelper

  before_filter :authenticate_user!

private
  def authenticate_user!
    return if signed_in?
    head 401
    false
  end
end