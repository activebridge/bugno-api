# frozen_string_literal: true

class API::V1::Base < Grape::API
  version 'v1'
  format :json

  desc 'Returns the current API version, v1.'
  get 'version' do
    { api_version: '1.0.0' }
  end
end
