# frozen_string_literal: true

class Integration::SlackSerializer < ApplicationSerializer
  attributes :id, :project_id, :type, :web_hook_info_channel, :workspace_url, :workspace_team, :action

  def web_hook_info_channel
    object.provider_data['web_hook_info']['channel']
  end

  def workspace_url
    object.provider_data['raw_info']['url']
  end

  def workspace_team
    object.provider_data['raw_info']['team']
  end

  def action
    instance_options[:action]
  end
end
