# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == Figaro.env.sidekiq_admin && password == Figaro.env.sidekiq_password
end

app = Rack::URLMap.new(
    "/" => Rails.application,
    "/sidekiq" => Sidekiq::Web
)

run app
