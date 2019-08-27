# frozen_string_literal: true

class Integration::SlackSerializer < ApplicationSerializer
  attributes :id, :project_id, :type, :web_hook_info_channel, :workspace_url, :workspace_team, :action

  def web_hook_info_channel
    object.provider_data.dig('raw_info', 'web_hook_info', 'channel')
  end

  def workspace_url
    workspace = object.provider_data.dig('raw_info', 'team_info', 'team', 'domain')
    I18n.t('slack_workspace_url', workspace: workspace)
  end

  def workspace_team
    object.provider_data.dig('raw_info', 'team_info', 'team', 'name')
  end

  def action
    instance_options[:action]
  end
end
