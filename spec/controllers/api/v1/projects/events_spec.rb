# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Projects::Events, type: :request do
  let(:user) { create(:user, :with_projects) }
  let(:project) { user.projects.first }
  let(:base_url) { "/api/v1/projects/#{project.id}/events" }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    let!(:events) { create_list(:event, 3, project: project) }
    let!(:event_twins) { create_list(:event, 2, :with_static_attributes, project: project) }

    subject do
      get(*request_params)
      json['data'].count
    end

    it { is_expected.to eq(4) }

    context '#index by status' do
      let!(:muted_events) { create_list(:event, 3, project: project, status: 'muted') }
      let!(:muted_event_twins) do
        create_list(:event, 2, :with_static_attributes,
                    project: project, status: 'muted',
                    title: 'slightly',
                    backtrace: 'different error')
      end
      let(:params) { { status: 'muted' } }

      it { is_expected.to eq(4) }
    end
  end

  context '#create' do
    let(:headers) { nil }
    let(:url) { "/api/v1/projects/#{project.api_key}/events" }
    let(:params) { attributes_for(:event) }

    subject { -> { post(*request_params) } }

    it { is_expected.to change(project.events, :count).by(1) }

    context 'without API key' do
      let(:api_key) { nil }
      let(:url) { "/api/v1/projects/#{api_key}/events" }

      subject do
        post(*request_params)
        response
      end

      it { is_expected.to have_http_status(401) }
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
    let(:params) { { event: { status: 'muted' } } }

    subject { -> { patch(*request_params) } }

    it { is_expected.to change { event.reload.status } }
  end
end
