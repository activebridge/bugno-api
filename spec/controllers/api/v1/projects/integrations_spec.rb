# frozen_string_literal: true

describe API::V1::Projects::Integrations do
  let(:user) { create(:user, :with_project) }
  let(:project) { user.projects.first }
  let(:base_url) { "/api/v1/projects/#{project.id}/integrations" }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  describe '#index' do
    subject { -> { get(*request_params) } }
    let!(:integrations) { create_list(:integration, 3, :slack, project: project) }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to respond_with_json_count(3) }
  end

  describe '#delete' do
    subject { -> { delete(*request_params) } }
    let(:url) { "#{base_url}/#{integration.id}" }
    let!(:integration) { create(:integration, :slack, project: project) }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to change(project.integrations, :count) }
  end
end
