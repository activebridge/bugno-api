# frozen_string_literal: true

describe Api do
  context 'GET /api/status' do
    subject { -> { get '/api/status' } }

    it { is_expected.to respond_with_status(200) }
  end
end
