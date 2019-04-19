# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Projects::ProjectUsers, type: :request do
  let!(:project) { create(:project) }
  let!(:project_users) { create_list(:project_user, 3, project: project) }
  let!(:unset_user) { create(:user) }
  let(:base_url) { "/api/v1/projects/#{project.id}/project_users" }
  let(:headers) { project.users.first.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    let(:url) { base_url }

    subject do
      get(*request_params)
      response
    end

    it { is_expected.to have_http_status(200) }
  end

  context '#create' do
    let(:url) { base_url }
    let(:params) { { email: unset_user.email } }

    subject do
      post(*request_params)
      response
    end

    it { is_expected.to have_http_status(201) }
  end
end
