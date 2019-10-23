# frozen_string_literal: true

class Api::V4::Base < Grape::API
  version 'v4'
  format :json

  desc 'Returns the current API version, v4.'
  get 'version' do
    { api_version: '4.0.0' }
  end
end
