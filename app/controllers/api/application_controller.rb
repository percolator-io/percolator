class Api::ApplicationController < ApplicationController
  doorkeeper_for :all

private
  def current_user
    @current_user ||= User.find doorkeeper_token.resource_owner_id
  end
end
