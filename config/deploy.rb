require 'yaml'
require 'capistrano_colors'
require "bundler/capistrano"
require 'rvm/capistrano'

set :rvm_ruby_string, '2.0.0'
set :rvm_type, :system

set :application, "sepia"
set :rails_env, "production"
set :scm, :git 
set :repository,  "https://github.com/yagince/sepia.git"
set :branch, "unicorn"
set :deploy_to, "/usr/local/#{application}"
set :keep_releases, 2
set :bundle_dir, File.join(fetch(:shared_path), 'bundle')
set :bundle_flags, "--quiet"

set :normalize_asset_timestamps, false
set :unicorn_pid_file, "/var/run/unicorn/unicorn_#{application}.pid"
set :sidekiq_pid_file, "/var/run/sidekiq/sidekiq.pid"
set :settings_yml, "config/settings.beta.yml"

set :user, 'vagrant' # TODO

host = 'chef-test' # TODO
role :web, host
role :app, host
role :db,  host, :primary => true
role :sidekiq, host

namespace :setup do
  task :fix_permissions do
    sudo "chown -R #{user}.#{user} #{deploy_to}"
  end
end
after "deploy:setup", "setup:fix_permissions"

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
    run "cd #{current_path}; nohup bundle exec sidekiq -e #{rails_env} -C #{current_path}/config/sidekiq.yml -P #{sidekiq_pid_file} >> #{current_path}/log/sidekiq.log 2>&1 &"
  end
  task :restart, :roles => :app do
    run "kill -s USR2 `cat #{unicorn_pid_file}`"
    run "kill -s USR2 `cat #{sidekiq_pid_file}`"
  end
  task :stop, :roles => :app do
    run "kill -s QUIT `cat #{unicorn_pid_file}`"
    run "cd #{current_path}; bundle exec sidekiqctl quiet #{sidekiq_pid_file} 10"
  end
end
load 'deploy/assets'

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
  raise "#{settings_yml} is not exist" unless File.exist? settings_yml
  yml = YAML.load(File.read(settings_yml))
  default_environment['TWITTER_KEY']     = yml["social"]["twitter"]["consumer_key"]
  default_environment['TWITTER_SECRET']  = yml["social"]["twitter"]["consumer_secret"]
  default_environment['FACEBOOK_KEY']    = yml["social"]["facebook"]["consumer_key"]
  default_environment['FACEBOOK_SECRET'] = yml["social"]["facebook"]["consumer_secret"]
  default_environment['GOOGLE_KEY']      = yml["social"]["google"]["consumer_key"]
  default_environment['GOOGLE_SECRET']   = yml["social"]["google"]["consumer_secret"]
  puts "--- complete set_env"
end

set_env
