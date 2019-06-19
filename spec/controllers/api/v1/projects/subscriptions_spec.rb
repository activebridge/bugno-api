# frozen_string_literal: true

require 'rails_helper'
require 'stripe_mock'

describe API::V1::Projects::Subscriptions, type: :request do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:stripe_card_token) { stripe_helper.generate_card_token }
  let(:user) { create(:user, :with_projects) }
  let(:project) { user.projects.first }
  let(:plan) { create(:plan) }
  let(:base_url) { "/api/v1/projects/#{project.id}/subscriptions" }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }
  before { StripeMock.start }
  after { StripeMock.stop }

  context '#create' do
    let(:params) { { project_id: project.id, plan_id: plan.id, stripe_token: stripe_card_token } }
    let(:result) { SubscriptionSerializer.new(project.subscription).to_json }

    subject do
      post(*request_params)
      response.body
    end

    it { is_expected.to eq(result) }

    context 'with invalid card' do
      before { StripeMock.prepare_card_error(:card_declined) }

      context 'does not create subscription' do
        subject { -> { post(*request_params) } }

        it { is_expected.not_to change(Subscription, :count) }
      end

      context 'return appropriate error message' do
        let(:result) { { 'error' => 'The card was declined' } }

        subject do
          post(*request_params)
          json
        end

        it { is_expected.to eq(result) }
      end
    end
  end
end
