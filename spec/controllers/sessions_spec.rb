# frozen_string_literal: true

require 'rails_helper'

describe 'sessions', type: :request do
  let(:user) { create(:user) }

  context '#create with valid credentials' do
    subject do
      login(user)
      response
    end

    it { is_expected.to have_http_status(200) }
  end
end
