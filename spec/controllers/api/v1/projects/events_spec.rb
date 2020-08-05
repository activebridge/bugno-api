# frozen_string_literal: true

describe API::V1::Projects::Events do
  let(:user) { create(:user, :with_project_and_subscription) }
  let(:project) { user.projects.first }
  let(:base_url) { "/api/v1/projects/#{project.id}/events" }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  describe '#index' do
    subject { -> { get(*request_params) } }
    let!(:event) { create(:event, project: project) }

    context 'return parent events' do
      let!(:occurrence) { create(:event, project: project, parent_id: event.id) }

      it { is_expected.to respond_with_json_count(1).at(:events) }
      it { is_expected.to respond_with_status(200) }
    end

    context 'by status' do
      let!(:muted_event) { create(:event, project: project, status: :muted) }
      let(:params) { { status: :muted } }

      it { is_expected.to respond_with_json_count(1).at(:events) }
    end
  end

  describe '#occurrences' do
    subject { -> { get(*request_params) } }
    let(:event) { create(:event, project: project) }
    let!(:occurrence) { create(:event, project: project, parent_id: event.id) }
    let(:url) { "#{base_url}/occurrences/#{event.id}" }

    it { is_expected.to respond_with_json_count(1).at(:events) }
    it { is_expected.to respond_with_status(200) }

    context 'when occurrence id' do
      let(:url) { "#{base_url}/occurrences/#{occurrence.id}" }

      it { is_expected.to respond_with_json_count(1).at(:events) }
    end
  end

  describe '#create' do
    subject { -> { post(*request_params) } }
    let(:headers) { nil }
    let(:url) { "/api/v1/projects/#{project.api_key}/events" }
    let(:params) { attributes_for(:event) }

    it { is_expected.to respond_with_status(201) }
    it { is_expected.to change(project.events, :count) }

    context 'when occurrence' do
      let!(:parent_event) { create(:event, :static_attributes, project: project, status: :resolved) }
      let!(:params) { attributes_for(:event, :static_attributes) }

      it 'updates parent event last_occurrence_at' do
        is_expected.to change { parent_event.reload.last_occurrence_at }
      end

      it 'changes parent event status to active' do
        is_expected.to change { parent_event.reload.status }
      end

      context 'when parent is muted' do
        let!(:parent_event) { create(:event, :static_attributes, project: project, status: :muted) }

        it { is_expected.not_to change { parent_event.reload.status } }
      end
    end

    context 'when missing subscription or it is expired' do
      before { project.subscription.update(events: -1) }
      let(:response_message) { { error: 'Subscription expired' } }

      it { is_expected.not_to change(project.events, :count) }
      it { is_expected.to respond_with_status(422) }
      it { is_expected.to respond_with_json(response_message) }
    end

    context 'when missing api key' do
      let(:api_key) { nil }
      let(:url) { "/api/v1/projects/#{api_key}/events" }

      it { is_expected.to respond_with_status(401) }
      it { is_expected.not_to change(project.events, :count) }
    end

    context 'when api key is invalid' do
      let(:api_key) { 'invalid_api_key' }
      let(:url) { "/api/v1/projects/#{api_key}/events" }

      it { is_expected.to respond_with_status(422) }
      it { is_expected.not_to change(project.events, :count) }
    end
  end

  describe '#show' do
    subject { -> { get(*request_params) } }
    let!(:event) { create(:event, project: project) }
    let(:url) { "#{base_url}/#{event.id}" }

    it { is_expected.to respond_with_status(200) }
  end

  describe '#update' do
    subject { -> { patch(*request_params) } }
    let(:event) { create(:event, user: nil, project: project) }
    let(:url) { "#{base_url}/#{event.id}" }
    let(:params) { { event: { status: :muted, user_id: user.id } } }

    it { is_expected.to change { event.reload.status } }
    it { is_expected.to change { event.reload.user_id } }

    context 'when status changed' do
      let(:occurrence) { create(:event, project: project, parent_id: event.id) }
      let(:url) { "#{base_url}/#{occurrence.id}" }

      it { is_expected.to change { occurrence.reload.status } }
    end
  end

  describe '#destroy' do
    subject { -> { delete(*request_params) } }
    let(:event) { create(:event, project: project) }
    let!(:occurrence) { create(:event, project: project, parent_id: event.id) }
    let(:url) { "#{base_url}/#{event.id}" }
    # let(:result) { EventSerializer.new(event).as_json }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to change(project.reload.events, :count) }
    # TODO: fix wrong symbolize in this matcher
    # it { is_expected.to respond_with_json(result) }
    context 'when event has occurrences' do
      it { is_expected.to change(Event.where(parent_id: event.id), :count) }
    end
  end
end
