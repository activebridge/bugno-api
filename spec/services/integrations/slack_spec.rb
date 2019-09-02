# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::SlackService do
  let(:event) { create(:event) }
  let(:integration) { create(:integration, :slack) }
  before do
    allow_any_instance_of(Slack::Notifier).to receive(:post).and_return(true)
  end

  subject do
    described_class.call(event: event, action: action, integration: integration, reason: reason)
  end

  context 'create event' do
    let(:action) { UserChannel::ACTIONS::CREATE_EVENT }
    let(:reason) { nil }

    it { is_expected.to be_truthy }
  end

  context 'update event' do
    let(:action) { UserChannel::ACTIONS::UPDATE_EVENT }
    let(:reason) { 'Occurrence' }

    it { is_expected.to be_truthy }
  end
end
