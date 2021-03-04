# frozen_string_literal: true

server ENV['PRODUCTION_SERVER_IP'], user: ENV['PRODUCTION_SERVER_USER'], roles: %w[app db web]
set :rails_env, ENV['CAPISTRANO_PRODUCTION_RAILS_ENV']
set :branch, ENV['CAPISTRANO_PRODUCTION_DEPLOY_BRANCH']
