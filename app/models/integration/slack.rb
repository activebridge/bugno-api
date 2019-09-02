# frozen_string_literal: true

class Integration::Slack < Integration
  def notify(event:, action:, reason: '')
    ::Integrations::SlackService.call(event: event, action: action, integration: self, reason: reason)
  end

  after_save :brodcast

  private

  def brodcast
    action = UserChannel::ACTIONS::CREATE_SLACK_INTEGRATION
    project.project_users.each do |project_user|
      ActionCable.server.broadcast("user_#{project_user.user_id}",
                                   Integration::SlackSerializer.new(self).as_json.merge(action: action))
    end
  end
end
