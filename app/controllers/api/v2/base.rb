# frozen_string_literal: true

module API
  module V2
    class Base < Grape::API
      version 'v2'
      format :json

      desc 'Returns the current API version, v2.'
      get 'version' do
        { api_version: '2.0.0' }
      end
    end
  end
end
