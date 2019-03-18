require 'rails_helper'

describe API::V3::Base, type: :request do

  context 'GET /api/v3/version' do
    subject do
      get '/api/v3/version'
      response
    end

    it { is_expected.to have_http_status(200) }
  end
end
