# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Projects::ProjectUsers, type: :request do
  let!(:project) { create(:project) }
  let!(:project_users) { create_list(:project_user, 3, project: project) }
  let!(:user_without_project) { create(:user) }
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
    let(:params) { { email: user_without_project.email } }

    subject do
      post(*request_params)
      response
    end

    it { is_expected.to have_http_status(201) }

    context 'not being project owner' do
      let(:user) { create(:user) }
      let(:ineligible_user) { project.project_users.create(user: user, role: 'collaborator') }
      let(:headers) { ineligible_user.user.create_new_auth_token }

      it { is_expected.not_to have_http_status(201) }
    end
  end
end
