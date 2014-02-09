class ApplicationController < ActionController::Base
  include UrlHelpers
  include AuthenticationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  #TODO: РАЗОБРАТЬСЯ!!!
  #protect_from_forgery with: :exception
end
