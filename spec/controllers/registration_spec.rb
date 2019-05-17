# frozen_string_literal: true

require 'rails_helper'

describe 'registration', type: :request do
  let(:user_attributes) { attributes_for(:user) }
  let(:base_url) { user_registration_path }
  let(:url) { base_url }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#create' do
    let(:params) { user_attributes }
    subject { -> { post(*request_params) } }

    it { is_expected.to change(User, :count).by(1) }
  end

  context '#update' do
    let!(:user) { create(:user) }
    let(:headers) { user.create_new_auth_token }
    let(:params) { user_attributes }

    subject do
      login(user)
      put(*request_params)
    end

    it { expect { subject }.to change { user.reload.attributes } }
  end
end
