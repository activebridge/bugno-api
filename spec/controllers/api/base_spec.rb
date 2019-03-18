# frozen_string_literal: true

require 'rails_helper'

describe API, type: :request do
  context 'GET /api/status' do
    subject do
      get '/api/status'
      response
    end

    it { is_expected.to have_http_status(200) }
  end
end