require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/rvm'
set :rvm_ruby_string, '2.0.0'
set :rvm_type, :system
require 'capistrano/bundler'
require 'capistrano/rails'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
