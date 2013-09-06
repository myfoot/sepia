# -*- coding: utf-8 -*-
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# 依存先のバージョンがぶつかってる
# gem 'redis-store', '1.1.3'
gem 'redis-store', git: "https://github.com/bricker/redis-store.git"
gem 'redis-actionpack', git: "https://github.com/bricker/redis-store.git"
gem 'redis-activesupport', git: "https://github.com/bricker/redis-store.git"
gem 'redis-rack', git: "https://github.com/bricker/redis-store.git"
gem 'redis-rails', '3.2.3'

#for settings
gem 'rails_config'

gem 'sass-rails', '~> 4.0.0.rc1'
# rails4では標準のcompass-railsではエラーになる
gem 'compass-rails', github: "milgner/compass-rails", branch: "rails4"
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 1.0.1'

# for authenticate
gem 'devise', github: 'idl3/devise', branch: 'rails4'#gem 'devise', '2.2.4'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-instagram'
gem 'protected_attributes'

#for view
gem 'slim-rails'
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"
gem 'underscore-rails'

# for background job
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

# xml parser
gem 'nokogiri'

# for paginate
gem 'kaminari'

# for clients
gem 'koala', "~> 1.7.0rc1" # facebook
gem 'twitter'
gem 'instagram'

gem 'mysql2', group: [:production, :development]

group :test do
  gem 'sqlite3'
  gem 'delorean'
end

group :development, :test do

  gem 'rspec-rails'
  gem 'spork'

  gem 'guard'
  gem 'guard-spork'
  gem 'guard-rspec'

  # for debug
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'debugger'
  gem 'pry'
  gem 'pry-rails'
end

group :doc do
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn', group: [:development, :production]

# Use Capistrano for deployment
group :development, :deployment do
  gem 'capistrano'
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
end
