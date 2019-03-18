# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/user'
  mount API::Base, at: '/api'
end
