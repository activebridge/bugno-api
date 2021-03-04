# frozen_string_literal: true

lock '~> 3.16.0'
set :application, 'bugno-api'
set :repo_url, 'git@github.com:activebridge/bugno-api.git'
set :deploy_to, "/home/dmytsuu/#{fetch :application}"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets',
       'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
set :keep_releases, 5
