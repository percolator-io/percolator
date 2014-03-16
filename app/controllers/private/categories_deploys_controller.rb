class Private::CategoriesDeploysController < ApplicationController
  before_filter :protect

  def create
    CategoriesDeployWorker.perform_async
    head :ok
  end

private
  def protect
    secret = params[:secret]
    head :forbidden if Figaro.env.github_webhook_secret != secret
  end

  #def payload
  #  ActiveSupport::JSON.decode params[:payload]
  #end
end