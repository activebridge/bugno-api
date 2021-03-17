# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'active_model_serializers', '~> 0.10.0'
gem 'activeadmin'
gem 'activerecord-import'
gem 'acts_as_list'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bugno'
gem 'device_detector'
gem 'devise'
gem 'devise_token_auth'
gem 'friendly_id'
gem 'grape'
gem 'grape-active_model_serializers'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape_devise_token_auth'
gem 'kaminari'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-slack', github: 'kmrshntr/omniauth-slack'
gem 'pg', '>= 0.18', '< 2.0'
gem 'premailer-rails'
gem 'puma'
gem 'pundit'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.4', '>= 5.2.4.2'
gem 'redis'
gem 'redis-rails'
gem 'slack-notifier'
gem 'slim'
gem 'sprockets', '~> 3.7.2'
gem 'stripe'

group :development, :test do
  gem 'awesome_print', require: 'ap'
  gem 'bullet'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rubocop'
end

group :development do
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rails', '~> 1.4'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'
  gem 'dotenv-rails'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'stripe-ruby-mock', '~> 3.0.1', require: 'stripe_mock'
end

gem 'rack-attack', '~> 6.3'
