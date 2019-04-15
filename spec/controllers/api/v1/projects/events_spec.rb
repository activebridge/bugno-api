# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Base::Projects, type: :request do
  let!(:user) { create(:user) }
  let!(:user_project) { create(:project_user, user: user) }
  let!(:event) { create(:event, project_id: user_project.project_id, user_id: user.id) }
  let(:base_url) { "/api/v1/projects/#{user_project.id}/events" }
  let(:headers) { user.create_new_auth_token }
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
    let(:project) { Project.find(user_project.project_id) }
    let(:url) { "/api/v1/projects/#{project.api_key}/events" }
    let(:params) { attributes_for(:event) }
    let(:headers) { nil }

    subject { -> { post(*request_params) } }

    it do
      post(*request_params)
      expect(response.status).to eq(201)
    end

    it { is_expected.to change(project.events, :count).by(1) }
  end

  context '#create with empty api key' do
    let(:api_key) { nil }
    let(:url) { "/api/v1/projects/#{api_key}/events" }
    let(:params) { attributes_for(:event) }
    let(:headers) { nil }

    it do
      post(*request_params)
      expect(response.status).to eq(401)
    end
  end

  context '#show' do
    let(:url) { "#{base_url}/#{event.id}" }

    subject do
      get(*request_params)
      response
    end

    it { is_expected.to have_http_status(200) }
  end

  context '#update' do
    let(:url) { "#{base_url}/#{event.id}" }
    let(:another_user) { create(:user) }
    let(:params) { { event: { status: 'muted', user_id: another_user.id } } }

    it do
      patch(*request_params)
      expect(response.status).to eq(200)
    end
  end
end
