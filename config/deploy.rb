require 'yaml'
require 'capistrano_colors'
require "bundler/capistrano"
require 'rvm/capistrano'

set :rvm_ruby_string, '2.0.0'
set :rvm_type, :system

set :application, "sepia"
set :rails_env, "production"
set :scm, :git 
set :repository,  "https://github.com/myfoot/sepia.git"
set :branch, "develop"
set :deploy_to, "/usr/local/#{application}"
set :deploy_via, :remote_cache
set :keep_releases, 2
set :bundle_dir, File.join(fetch(:shared_path), 'bundle')
set :bundle_flags, "--quiet"

set :normalize_asset_timestamps, false
set :unicorn_pid_file, "/var/run/unicorn/unicorn_#{application}.pid"
set :sidekiq_pid_file, "/var/run/sidekiq/sidekiq.pid"
set :settings_yml, "config/settings.beta.yml"
set :deploy_yml, "config/deploy.yml"

namespace :setup do
  task :fix_permissions, :roles => :app do
    sudo "chown -R #{user}.#{user} #{deploy_to}"
  end
end
after "deploy:setup", "setup:fix_permissions"

namespace :deploy do
  task :start, :roles => :app do
    # run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
    # run "cd #{current_path}; nohup bundle exec sidekiq -e #{rails_env} -C #{current_path}/config/sidekiq.yml -P #{sidekiq_pid_file} >> #{current_path}/log/sidekiq.log 2>&1 &"
    sudo "monit start unicorn"
    sudo "monit start sidekiq"
  end
  task :restart, :roles => :app do
    run "kill -s USR2 `cat #{unicorn_pid_file}`"
    # run "cd #{current_path}; bundle exec sidekiqctl stop #{sidekiq_pid_file} 10"
    # run "cd #{current_path}; nohup bundle exec sidekiq -e #{rails_env} -C #{current_path}/config/sidekiq.yml -P #{sidekiq_pid_file} >> #{current_path}/log/sidekiq.log 2>&1 &"
    sudo "monit restart sidekiq"
  end
  task :stop, :roles => :app do
    # run "kill -s QUIT `cat #{unicorn_pid_file}`"
    # run "cd #{current_path}; bundle exec sidekiqctl stop #{sidekiq_pid_file} 10"
    sudo "monit stop unicorn"
    sudo "monit stop sidekiq"
  end
end
after "deploy:update_code", "deploy:cleanup"

namespace :db do
  task :init, roles: :db do 
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:create db:migrate"
  end
  task :reset, roles: :db do 
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:drop db:create db:migrate"
  end
end

namespace :settings do
  task :ymls, roles: :app do 
    run "cd #{current_path}; ln -s #{current_path}/config/settings.yml.sample #{current_path}/config/settings.yml"
  end
end
after "deploy:create_symlink", "settings:ymls"

def set_env
  puts "--- start set_env"

  raise "#{deploy_yml} is not exist" unless File.exist? deploy_yml
  deploy_settings = YAML.load(File.read(deploy_yml))
  puts "DeploySettings : #{deploy_settings}"
  set  :user,    deploy_settings['user']
  role :web,     *deploy_settings['host']['web']
  role :app,     *deploy_settings['host']['app']
  role :db,      *deploy_settings['host']['db'], :primary => true
  role :sidekiq, *deploy_settings['host']['sidekiq']

  puts "--- complete set_env"
end

set_env
