set :application, "dashboard"
set :repository,  "git@github.com:Stylitics/client_dashboard.git"
set :domain, "catalin@198.199.70.50"

set :deploy_to, "/apps/#{application}"

set :scm, :git

ssh_options[:paranoid] = false
ssh_options[:forward_agent] = true

set :rake, "/usr/local/rvm/gems/ruby-2.0.0-p0@global/bin/rake"

set :user, "catalin"
set :runner, nil
set :use_sudo, false

role :web, domain
role :app, domain
role :db,  domain, :primary => true
role :db,  domain

namespace :deploy do
  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    run "kill -s USR2 `cat tmp/unicorn.dashboard.pid`" if File.exists?("#{current_path}/tmp/unicorn.dashboard.pid")
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    run "kill -s QUIT `cat tmp/unicorn.dashboard.pid`" if File.exists?("#{current_path}/tmp/unicorn.dashboard.pid")
  end
end

desc "Create symlinks"
task :create_assets_symlink do
  invoke_command "cd /apps/#{application}/current/public/ && ln -s /apps/#{application}/uploads uploads", :via => run_method
  invoke_command "cd /apps/#{application}/current/tmp/ && mkdir runs", :via => run_method
end

after "deploy", "create_assets_symlink"
after "deploy:migrations", "create_assets_symlink"
