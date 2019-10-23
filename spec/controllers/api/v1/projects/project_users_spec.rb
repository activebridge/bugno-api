# frozen_string_literal: true

describe Api::V1::Projects::ProjectUsers do
  let(:user) { create(:user, :with_project) }
  let(:project) { user.projects.first }
  let(:base_url) { "/api/v1/projects/#{project.id}/project_users" }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  describe '#index' do
    subject { -> { get(*request_params) } }
    let!(:project_users) { create_list(:project_user, 3, project: project) }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to respond_with_json_count(project.users.count) }
  end

  describe '#create' do
    subject { -> { post(*request_params) } }
    let(:collaborator) { create(:user) }
    let(:params) { { email: collaborator.email } }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to change(project.users, :count) }

    context 'when collaborator' do
      let(:headers) { collaborator.create_new_auth_token }
      let(:user_without_a_project) { create(:user) }
      let(:params) { { email: user_without_a_project.email } }

      it { is_expected.to respond_with_status(403) }
      it { is_expected.not_to change(project.project_users, :count) }
    end

    context 'when user is not registered' do
      let(:params) { { email: Faker::Internet.email } }

      it { is_expected.to respond_with_status(200) }
      it { is_expected.not_to change(project.users, :count) }
    end
  end

  describe '#delete' do
    subject { -> { delete(*request_params) } }
    let!(:project_user) { create(:project_user, project: project) }
    let(:url) { "#{base_url}/#{project_user.id}" }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to change(project.users, :count) }
  end
end
