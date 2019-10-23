# frozen_string_literal: true

Rails.application.routes.draw do
  begin
  ActiveAdmin.routes(self)
  rescue StandardError
    ActiveAdmin::DatabaseHitDuringLoad
end

  mount ActionCable.server, at: '/cable'
  mount Api::Base, at: '/api'
  mount GrapeSwaggerRails::Engine, at: '/documentation'
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    omniauth_callbacks: 'omniauth_callbacks',
    token_validations: 'token_validations'
  }
end
