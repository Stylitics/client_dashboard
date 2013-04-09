source 'https://rubygems.org'
ruby "2.0.0"

gem "Ascii85", "~> 1.0.2"

gem 'rails', '3.2.12'
gem 'mongoid', '~> 3.0.0'
gem 'mongoid_slug'

gem 'unicorn'
gem 'foreman'

gem 'jquery-rails'

gem 'turbolinks'
gem 'jquery-turbolinks'
# we'll see if this is cooler than pjax

gem 'cache_digests'
gem 'dalli'

gem 'simple_form'

gem 'capistrano'
gem 'rvm-capistrano'

gem 'rmagick'
gem 'carrierwave'
gem 'nokogiri'

gem 'kaminari'

gem 'prawn', '~> 1.0.0.rc2'

gem 'devise'

group :production do
  gem 'newrelic_rpm'
end

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'bootstrap-sass', '~> 2.3.1.0'
  gem 'font-awesome-sass-rails'

  gem 'uglifier', '>= 1.0.3'

  gem 'therubyracer', :platforms => :ruby
end

group :test, :development do
  gem 'spork'
  gem 'rspec-rails', '~> 2.12.2'
  gem 'mongoid-rspec'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-pow'
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
