require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'wrong/adapters/rspec'
  require 'webmock/rspec'
  require 'sidekiq/testing'

  WebMock.disable_net_connect!(allow_localhost: true)
  Sidekiq::Testing.inline!

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
end

RSpec.configure do |config|
  config.render_views
  config.include FactoryGirl::Syntax::Methods
  config.include SessionTestHelper

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.before :all do
    Elastic::Indices.remove
    Elastic::Indices.create
    Elastic::Indices.put_mappings
  end

  config.after :each do
    Elastic::Indices.clean
  end

  config.after :all do
    Elastic::Indices.remove
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

def fixture_file_path(name)
  File.join(Dir.pwd, 'spec', 'fixtures', name)
end
