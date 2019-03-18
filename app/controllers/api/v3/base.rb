# frozen_string_literal: true

module API
  module V3
    class Base < Grape::API
      version 'v3'
      format :json

      desc 'Returns the current API version, v3.'
      get 'version' do
        { api_version: '3.0.0' }
      end
    end
  end
end
