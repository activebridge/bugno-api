# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Projects::ProjectUsers, type: :request do
  let(:user) { create(:user, :with_projects) }
  let(:project) { user.projects.first }
  let(:base_url) { "/api/v1/projects/#{project.id}/project_users" }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    let!(:project_users) { create_list(:project_user, 3, project: project) }

    subject do
      get(*request_params)
      json.count
    end

    it { is_expected.to eq(project.users.count) }
  end

  context '#create' do
    let!(:user_without_project) { create(:user) }
    let(:params) { { email: user_without_project.email } }

    subject { -> { post(*request_params) } }

    it { is_expected.to change(project.users, :count).by(1) }

    context 'not being project owner' do
      let(:user) { create(:user, :with_projects_as_collaborator) }
      let(:project) { user.projects.first }

      it { is_expected.not_to change(project.users, :count) }
    end

    context 'invite by email should not add new project_user' do
      let(:params) { { email: Faker::Internet.email } }

      it { is_expected.not_to change(project.users, :count) }
    end
  end

  context '#delete' do
    let!(:project_user) { create(:project_user, project: project) }
    let(:url) { "#{base_url}/#{project_user.id}" }

    subject { -> { delete(*request_params) } }

    it { is_expected.to change(project.users, :count).by(-1) }
  end
end
