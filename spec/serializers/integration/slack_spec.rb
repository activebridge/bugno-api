# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration::SlackSerializer do
  let(:integration) { create(:integration, :slack) }
  let(:action) { 'CREATE_SLACK_INTEGRATION' }
  let(:workspace) { integration.provider_data.dig('raw_info', 'team_info', 'team', 'domain') }
  let(:workspace_url) { I18n.t('slack_workspace_url', workspace: workspace) }

  subject do
    described_class.new(integration, action: action).as_json
  end

  it {
    is_expected.to include(id: integration.id,
                           project_id: integration.project_id,
                           type: integration.type,
                           web_hook_info_channel: integration.provider_data.dig('raw_info', 'web_hook_info', 'channel'),
                           workspace_url: workspace_url,
                           workspace_team: integration.provider_data.dig('raw_info', 'team_info', 'team', 'name'),
                           action: action)
  }
end
