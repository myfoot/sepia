set :stage, :staging

set :rails_env, "production"
set :assets_roles, :app
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
set :bundle_flags, '--quiet'

set :bundle_roles, :app

set :branch, "develop"
set :keep_releases, 2

set :unicorn_pid_file, "/var/run/unicorn/unicorn_#{fetch(:application)}.pid"
set :sidekiq_pid_file, "/var/run/sidekiq/sidekiq.pid"
set :settings_yml, "config/settings.beta.yml"
set :deploy_yml, "config/deploy.beta.yml"

set_env

namespace :deploy do
  task :start do
    on roles(:app), in: :sequence, wait: 1 do
      # run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
      execute :sudo, "monit start unicorn"
    end
    on roles(:sidekiq), in: :sequence, wait: 1 do 
      # run "cd #{current_path}; nohup bundle exec sidekiq -e #{rails_env} -C #{current_path}/config/sidekiq.yml -P #{sidekiq_pid_file} >> #{current_path}/log/sidekiq.log 2>&1 &"
      execute :sudo, "monit start sidekiq"
    end
  end
  task :restart do
    on roles(:app), in: :sequence, wait: 1 do
      # run "cd #{current_path}; bundle exec sidekiqctl stop #{sidekiq_pid_file} 10"
      execute :kill, "-s", "USR2", "`cat #{fetch(:unicorn_pid_file)}`"
    end
    on roles(:sidekiq), in: :sequence, wait: 1 do
      # run "cd #{current_path}; nohup bundle exec sidekiq -e #{rails_env} -C #{current_path}/config/sidekiq.yml -P #{sidekiq_pid_file} >> #{current_path}/log/sidekiq.log 2>&1 &"
      execute :sudo, "monit start sidekiq"
    end
  end
  task :stop do
    on roles(:app), in: :sequence, wait: 1 do
      # run "kill -s QUIT `cat #{unicorn_pid_file}`"
      execute :sudo, "monit stop unicorn"
    end
    on roles(:sidekiq), in: :sequence, wait: 1 do
      # run "cd #{current_path}; bundle exec sidekiqctl stop #{sidekiq_pid_file} 10"
      execute :sudo, "monit stop sidekiq"
    end
  end
end
