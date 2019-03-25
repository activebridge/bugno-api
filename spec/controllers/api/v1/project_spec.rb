# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Base::Projects, type: :request do
  let(:valid_params) { attributes_for(:project) }
  let!(:user) { create(:user) }
  let!(:user_project) { create(:project_user, user: user) }
  let(:url) { '/api/v1/projects' }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    subject do
      get(*request_params)
      response
    end

    it { is_expected.to have_http_status(200) }
  end

  context '#create' do
    let(:params) { { project: valid_params } }

    subject { -> { post(*request_params) } }

    it { is_expected.to change(user.projects, :count).by(1) }
  end
end
