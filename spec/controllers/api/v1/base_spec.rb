# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Base, type: :request do
  context 'GET /api/v1/version' do
    subject do
      get '/api/v1/version'
      response
    end

    it { is_expected.to have_http_status(200) }
  end
end
