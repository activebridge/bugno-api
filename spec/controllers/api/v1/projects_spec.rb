# frozen_string_literal: true

describe API::V1::Projects do
  let!(:user) { create(:user) }
  let(:valid_params) { attributes_for(:project) }
  let(:base_url) { '/api/v1/projects' }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  describe '#index' do
    subject { -> { get(*request_params) } }
    let!(:project_users) { create_list(:project_user, 3, user: user) }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to respond_with_json_count(3) }
  end

  describe '#create' do
    subject { -> { post(*request_params) } }
    let(:params) { { project: valid_params } }

    it { is_expected.to respond_with_status(201) }
    it { is_expected.to change(user.projects, :count).by(1) }
  end

  describe '#show' do
    subject { -> { get(*request_params) } }
    let(:url) { "#{base_url}/#{project_user.project_id}" }
    let(:project_user) { create(:project_user, user: user) }
    let(:project) { ProjectSerializer.new(project_user.project, include_stripe_api_key: true).as_json }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to respond_with_json(project) }
  end

  describe '#update' do
    subject { -> { patch(*request_params) } }
    let(:url) { "#{base_url}/#{project_user.project.id}" }
    let(:params) { { project: valid_params } }
    let(:project_user) { create(:project_user, user: user) }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to change { project_user.project.reload.attributes } }
  end

  describe '#destroy' do
    subject { -> { delete(*request_params) } }
    let(:url) { "#{base_url}/#{project_user.project_id}" }
    let(:params) { { id: project_user.project_id } }
    let!(:project_user) { create(:project_user, user: user) }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to change(user.projects, :count) }
  end
end
