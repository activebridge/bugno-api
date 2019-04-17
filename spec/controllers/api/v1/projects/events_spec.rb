# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Projects::Events, type: :request do
  let(:user) { create(:user, :with_projects) }
  let(:project) { user.projects.first }
  let!(:events) { create_list(:event, 3, project: project) }
  let(:base_url) { "/api/v1/projects/#{project.id}/events" }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    let(:url) { base_url }
    before { get(*request_params) }

    it '200 OK' do
      expect(response).to have_http_status(200)
    end

    it "project's events" do
      expect(json['data'].count).to eq(events.count)
    end
  end

  context '#index by status' do
    let!(:other_status_events) { create_list(:event, 3, project: project, status: 'muted') }
    let(:params) { { status: 'active' } }
    let(:url) { base_url }

    it do
      get(*request_params)
      expect(json['data'].count).to eq(events.count)
    end
  end

  context '#create' do
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
    let!(:event) { create(:event, project: project) }
    let(:url) { "#{base_url}/#{event.id}" }

    subject do
      get(*request_params)
      response
    end

    it { is_expected.to have_http_status(200) }
  end

  context '#update' do
    let!(:event) { create(:event, project: project) }
    let(:url) { "#{base_url}/#{event.id}" }
    let(:assign_user) { create(:user) }
    let(:params) { { event: { status: 'muted', user_id: assign_user.id } } }

    it do
      patch(*request_params)
      expect(response.status).to eq(200)
    end
  end
end
