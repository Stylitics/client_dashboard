# RVM bootstrap
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'

set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_type, :user

set :stages, %w(production staging)
set :default_stage, 'staging'

set :deploy_to, "/apps/#{application}"

set :scm, :git

ssh_options[:paranoid] = false
ssh_options[:forward_agent] = true

set :user, "catalin"
set :runner, nil
set :use_sudo, false

role :web, domain
role :app, domain
role :db,  domain, :primary => true
role :db,  domain

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

desc "Create symlinks"
task :create_assets_symlink do
  invoke_command "cd /apps/#{application}/current/public/ && ln -s /apps/#{application}/uploads uploads", :via => run_method
end

after "deploy", "create_assets_symlink"
after "deploy:migrations", "create_assets_symlink"

require 'bundler/capistrano'

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end

after "deploy:update_code", "rvm:trust_rvmrc"