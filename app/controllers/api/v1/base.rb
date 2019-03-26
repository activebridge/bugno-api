# frozen_string_literal: true

class API::V1::Base < Grape::API
  auth :grape_devise_token_auth, resource_class: :user
  helpers GrapeDeviseTokenAuth::AuthHelpers

  formatter :json, Grape::Formatter::FastJsonapi
  formatter :jsonapi, Grape::Formatter::FastJsonapi

  helpers do
    def declared_params
      declared(params, include_missing: false)
    end
  end

  version 'v1'
  format :json

  desc 'Returns the current API version, v1.'
  get 'version' do
    { api_version: '1.0.0' }
  end

  before { authenticate_user! }
  mount API::V1::Projects
end
