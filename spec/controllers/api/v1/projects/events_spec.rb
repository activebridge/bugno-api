# frozen_string_literal: true

describe API::V1::Projects::Events do
  let(:user) { create(:user, :with_projects) }
  let(:project) { user.projects.first }
  let(:base_url) { "/api/v1/projects/#{project.id}/events" }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index parent events' do
    let!(:events) { create_list(:event, 3, project: project) }
    let!(:occurrences) { create_list(:event, 2, :static_attributes, project: project) }

    subject do
      get(*request_params)
      json['events'].count
    end

    it { is_expected.to eq(4) }

    context '#index by status' do
      let!(:muted_events) { create_list(:event, 3, project: project, status: 'muted') }
      let!(:muted_occurrences) do
        create_list(:event, 2, :static_attributes,
                    project: project, status: 'muted',
                    title: 'slightly',
                    backtrace: 'different error')
      end
      let(:params) { { status: 'muted' } }

      it { is_expected.to eq(4) }
    end
  end

  context '#occurrences' do
    let!(:parent_event) { create(:event, :static_attributes, project: project) }
    let!(:occurrences) { create_list(:event, 3, :static_attributes, project: project) }
    let(:url) { "#{base_url}/occurrences/#{parent_event.id}" }

    subject do
      get(*request_params)
      json['events'].count
    end

    it { is_expected.to eq(3) }
  end

  context '#create' do
    let(:headers) { nil }
    let(:url) { "/api/v1/projects/#{project.api_key}/events" }
    let(:params) { attributes_for(:event) }

    subject do
      post(*request_params)
      response
    end

    context do
      let!(:subscription) { create(:subscription, project_id: project.id) }
      let(:result) { { 'message' => 'event captured' } }

      it { expect { subject }.to change(project.events, :count).by(1) }
      it { expect(subject.body).to eq(result.to_json) }

      context 'update parent event to active if from resolved' do
        let!(:parent_event) { create(:event, :static_attributes, project: project, status: :resolved) }
        let!(:params) { attributes_for(:event, :static_attributes) }

        it { expect { subject }.to change { parent_event.reload.status } }

        context 'should not update muted' do
          let!(:parent_event) { create(:event, :static_attributes, project: project, status: :muted) }
          it { expect { subject }.not_to change { parent_event.reload.status } }
        end

        context 'update parent event last_occurrence_at' do
          let!(:parent_event) { create(:event, :static_attributes, project: project) }
          let!(:params) { attributes_for(:event, :static_attributes) }

          it { expect { subject }.to change { parent_event.reload.last_occurrence_at } }
        end
      end

      context 'invalid subscription' do
        before { project.subscription.update(events: -1) }
        let(:result) { { 'message' => 'subscription is absent' } }

        it { expect { subject }.not_to change(project.events, :count) }
        it { is_expected.to have_http_status(403) }
        it { expect(subject.body).to eq(result.to_json) }
      end
    end
    context 'without api key' do
      let(:api_key) { nil }
      let(:url) { "/api/v1/projects/#{api_key}/events" }

      it { expect { subject }.not_to change(project.events, :count) }
      it { is_expected.to have_http_status(401) }

      context 'invalid api key' do
        let(:api_key) { 'invalid_api_key' }
        let(:result) { { 'message' => 'api-key is invalid' } }

        it { expect(subject.body).to eq(result.to_json) }
      end
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
    subject { -> { patch(*request_params) } }
    let(:event) { create(:event, user: nil, project: project) }
    let(:url) { "#{base_url}/#{event.id}" }
    let(:params) { { event: { status: :muted, user_id: user.id } } }

    it { is_expected.to change { event.reload.status } }
    it { is_expected.to change { event.reload.user_id } }

    context 'when status changed' do
      it 'creates activity' do
        is_expected.to change(PublicActivity::Activity, :count)
      end

      context do
        let!(:occurrences) { create_list(:event, 2, :static_attributes, project: project) }
        let(:url) { "#{base_url}/#{occurrences.first.id}" }

        it 'updates occurrences as well' do
          is_expected.to change { occurrences.last.reload.status }
        end
      end
    end
  end
end
