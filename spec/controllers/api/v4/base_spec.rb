require 'rails_helper'

describe API::V4::Base, type: :request do

  context 'GET /api/v4/version' do
    subject do
      get '/api/v4/version'
      response
    end

    it { is_expected.to have_http_status(200) }
  end
end
