# -*- coding: utf-8 -*-
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'redis-rails', '4.0.0'

#for settings
gem 'rails_config'

gem 'sass-rails', '~> 4.0.0.rc1'
gem 'compass-rails', github: 'Compass/compass-rails'
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
gem 'omniauth-foursquare'
gem 'protected_attributes'

#for view
gem 'slim-rails'
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"
gem "bootstrap-switch-rails", "2.0.0"
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
gem 'foursquare2'

# for api server
gem "doorkeeper", "1.0.0"
gem "grape", "0.6.1"
gem "grape-doorkeeper", github: "yagince/grape-doorkeeper"

gem 'mysql2', group: [:production, :development]

gem 'ninja', github: 'myfoot/ninja'

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
  gem 'capistrano', "3.0.1"
  gem 'capistrano-rails', '1.1.0'
  gem 'capistrano-bundler', '1.1.1'
  gem 'capistrano-rvm', '0.1.0'
end
