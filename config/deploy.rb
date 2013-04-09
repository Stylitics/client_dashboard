set :application, "dashboard"
set :repository,  "git@github.com:Stylitics/client_dashboard.git"
set :domain, "catalin@198.199.70.50"

# set :deploy_to, "/apps/code/#{application}"
set :deploy_to, "/apps/#{application}"

set :scm, :git

ssh_options[:paranoid] = false
ssh_options[:forward_agent] = true

# vps1-4 @ trisme
# set :rake, "/usr/local/bin/rake"
set :rake, "/usr/bin/rake"

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
