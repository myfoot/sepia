# -*- coding: utf-8 -*-
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'mysql2'
# 依存先のバージョンがぶつかってる
# gem 'redis-store', '1.1.3'
gem 'redis-store', github: "bricker/redis-store"
gem 'redis-actionpack', github: "bricker/redis-store"
gem 'redis-activesupport', github: "bricker/redis-store"
gem 'redis-rack', github: "bricker/redis-store"
gem 'redis-rails', '3.2.3'

#for settings
gem 'rails_config'

gem 'sass-rails', '~> 4.0.0.rc1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.0.1'

# for authenticate
gem 'devise', github: 'idl3/devise', branch: 'rails4'#gem 'devise', '2.2.4'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'protected_attributes'

#for view
gem 'slim-rails'
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"

# for background job
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem 'nokogiri'

group :development, :test do
  gem 'rspec-rails'
  gem 'spork'

  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'
end

group :doc do
  gem 'sdoc', require: false
end

group :test do
  gem 'sqlite3'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
