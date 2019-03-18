require 'rails_helper'

describe API::V2::Base, type: :request do

  context 'GET /api/v2/version' do
    subject do
      get '/api/v2/version'
      response
    end

    it { is_expected.to have_http_status(200) }
  end
end
