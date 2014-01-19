source 'https://rubygems.org'

gem 'rails', '4.0.2'

gem 'pg'

gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer'

gem 'jquery-rails'

gem 'puma'
gem 'sidekiq'
gem 'addressable'
gem 'elasticsearch'

platform :rbx do
  gem 'rubysl'
  gem 'racc'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'wrong', github: 'pludoni/wrong'

  gem 'rubysl-test-unit', platform: :rbx
  gem 'webmock'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'
