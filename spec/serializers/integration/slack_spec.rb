# frozen_string_literal: true

describe Integration::SlackSerializer do
  subject { described_class.new(integration).as_json }
  let(:integration) { create(:integration, :slack) }
  let(:workspace) { integration.provider_data.dig('raw_info', 'team_info', 'team', 'domain') }
  let(:workspace_url) { I18n.t('slack_workspace_url', workspace: workspace) }
  let(:web_hook_info_channel) { integration.provider_data.dig('raw_info', 'web_hook_info', 'channel') }
  let(:workspace_team) { integration.provider_data.dig('raw_info', 'team_info', 'team', 'name') }

  it { is_expected.to have_name(:id).with_value(integration.id) }
  it { is_expected.to have_name(:project_id).with_value(integration.project_id) }
  it { is_expected.to have_name(:type).with_value(integration.type) }
  it { is_expected.to have_name(:workspace_url).with_value(workspace_url) }
  it { is_expected.to have_name(:web_hook_info_channel).with_value(web_hook_info_channel) }
  it { is_expected.to have_name(:workspace_team).with_value(workspace_team) }
end
