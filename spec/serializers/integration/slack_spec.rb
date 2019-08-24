# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration::SlackSerializer do
  let(:integration) { create(:integration, :slack) }
  let(:action) { 'CREATE_SLACK_INTEGRATION' }

  subject do
    described_class.new(integration, action: action).as_json
  end

  it {
    is_expected.to include(id: integration.id,
                           project_id: integration.project_id,
                           type: integration.type,
                           web_hook_info_channel: integration.provider_data['web_hook_info']['channel'],
                           workspace_url: integration.provider_data['raw_info']['url'],
                           workspace_team: integration.provider_data['raw_info']['team'],
                           action: action)
  }
end
