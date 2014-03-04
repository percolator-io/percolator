class Web::ApplicationController < ApplicationController
  include WebAuthenticationHelper
  include StoredPath

  protect_from_forgery with: :exception
end
