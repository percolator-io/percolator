# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'sidekiq/web'

app = Rack::URLMap.new(
    "/" => Rails.application,
    "/sidekiq" => Sidekiq::Web
)

run app
