# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Projects::Integrations, type: :request do
  let(:user) { create(:user, :with_projects) }
  let(:project) { user.projects.first }
  let(:base_url) { "/api/v1/projects/#{project.id}/integrations" }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    let!(:integrations) { create_list(:integration, 3, :slack, project: project) }

    subject do
      get(*request_params)
      json.count
    end

    it { is_expected.to eq(integrations.count) }
  end

  context '#delete' do
    let!(:integration) { create(:integration, :slack, project: project) }
    let(:url) { "#{base_url}/#{integration.id}" }

    subject { -> { delete(*request_params) } }

    it { is_expected.to change(project.integrations, :count).by(-1) }
  end
end
