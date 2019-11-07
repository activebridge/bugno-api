# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'active_model_serializers', '~> 0.10.0'
gem 'activeadmin'
gem 'acts_as_list'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bugno', github: 'activebridge/bugno-ruby'
gem 'device_detector'
gem 'devise'
gem 'devise_token_auth'
gem 'friendly_id'
gem 'grape'
gem 'grape-active_model_serializers'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape_devise_token_auth'
gem 'groupdate'
gem 'kaminari'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-slack', github: 'kmrshntr/omniauth-slack'
gem 'pg', '>= 0.18', '< 2.0'
gem 'public_activity'
gem 'puma'
gem 'pundit'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
gem 'redis'
gem 'redis-rails'
gem 'slack-notifier'
gem 'slim'
gem 'stripe'

group :development, :test do
  gem 'awesome_print', require: 'ap'
  gem 'bullet'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rubocop'
end

group :development do
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
  gem 'stripe-ruby-mock', '~> 2.5.7', require: 'stripe_mock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
