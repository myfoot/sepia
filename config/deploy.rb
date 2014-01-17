set :application, "sepia"
set :repo_url, "https://github.com/myfoot/sepia.git"

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/usr/local/#{fetch(:application)}"
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :db do
  task :init do
    on roles(:db), in: :parallel do
      within current_path do 
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "db:create db:migrate"
        end
      end
    end
  end
  task :reset do
    on roles(:db), in: :parallel do
      within current_path do 
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :rake, "db:drop db:create db:migrate"
        end
      end
    end
  end
end

namespace :settings do
  task :ymls do
    on roles(:app), in: :parallel do
      within current_path do 
        execute :ln, "-s", "#{current_path}/config/settings.yml.sample", "#{current_path}/config/settings.yml"
      end
    end
  end
end
after "deploy:symlink:release", "settings:ymls"

def set_env
  puts "--- start set_env"

  raise "#{fetch(:deploy_yml)} is not exist" unless File.exist? fetch(:deploy_yml)
  deploy_settings = YAML.load(File.read(fetch(:deploy_yml)))
  puts "DeploySettings : #{deploy_settings}"
  set  :user,    deploy_settings['user']
  role :web,     *deploy_settings['host']['web']
  role :app,     *deploy_settings['host']['app']
  role :db,      *deploy_settings['host']['db'], :primary => true
  role :sidekiq, *deploy_settings['host']['sidekiq']

  puts "--- complete set_env"
end
