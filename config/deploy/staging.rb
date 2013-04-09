set :rails_env, "production"
set :rvm_ruby_string, 'ruby-2.0.0-p0'

role :web, domain
role :app, domain
role :db,  domain, :primary => true
role :db,  domain