# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'activeadmin'
gem 'acts_as_list'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'devise_token_auth'
gem 'fast_jsonapi'
gem 'grape'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape_devise_token_auth'
gem 'grape_fast_jsonapi'
gem 'kaminari'
gem 'omniauth'
gem 'omniauth-github'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'pundit'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
gem 'slim'

group :development, :test do
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
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
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
