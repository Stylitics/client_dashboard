source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.12'
gem 'pg'

gem 'unicorn'
gem 'foreman'

gem 'jquery-rails'
gem 'turbolinks'

gem 'cache_digests'
gem 'dalli'

gem 'simple_form'

gem 'capistrano'

gem 'rmagick'
gem 'carrierwave'
gem 'nokogiri'

gem 'kaminari'

gem 'prawn', '~> 1.0.0.rc2'

gem 'devise'

gem 'babosa', '0.3.9'
gem 'friendly_id', '~> 4.0.9'

gem 'rinruby'

group :production do
  gem 'newrelic_rpm'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'spork'
  gem 'rspec-rails', '~> 2.12.2'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-livereload'
  gem 'rack-livereload'
  # heroku doesn't run with these
  gem 'rb-fsevent', require: false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl', require: false if RUBY_PLATFORM =~ /darwin/i
end

group :test do
  gem 'email_spec'
  gem 'database_cleaner'
end

group :development do
  gem 'rack-mini-profiler'
  gem 'pry-rails'
end
