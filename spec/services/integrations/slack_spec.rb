# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integrations::SlackService do
  let(:integration) { create(:integration, :slack) }

  subject do
  end

  context 'create event' do
    let(:result) {}

    it { is_expected.to eq(result) }
  end
end
