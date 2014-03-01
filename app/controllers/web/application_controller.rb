class Web::ApplicationController < ApplicationController
  include WebAuthenticationHelper

  protect_from_forgery with: :exception
end
