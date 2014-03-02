class ApplicationController < ActionController::Base
  include UrlHelpers

  def user_for_paper_trail
    current_user.id
  end
end
