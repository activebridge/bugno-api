# frozen_string_literal: true

require 'rails_helper'

describe 'registration', type: :request do
  let(:user_attributes) { attributes_for(:user) }

  context '#create' do
    subject do
      post user_registration_path, params: user_attributes
      response
    end

    it { is_expected.to have_http_status(200) }
    it { expect { subject }.to change(User, :count).by(1) }
  end
end
