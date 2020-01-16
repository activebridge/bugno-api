# frozen_string_literal: true

class Integrations::SlackService < ApplicationService
  ERROR_RESPONSES = %w[user_not_found channel_not_found channel_is_archived action_prohibited
                       posting_to_general_channel_denied no_service no_service_id no_team team_disabled
                       invalid_token]

  EVENT_STATUS_COLORS = {
    'active' => 'danger',
    'muted' => '',
    'resolved' => 'good'
  }

  EVENT_ACTIONS = {
    'CREATE_EVENT' => 'event_create_notification',
    'UPDATE_EVENT' => 'event_update_notification'
  }

  def call
    notifier.post(attachments: [attachment])
  rescue StandardError => e
    integration.destroy if invalid_webhook?(e)
  end

  private

  def notifier
    @notifier ||= ::Slack::Notifier.new(integration.provider_data.dig('raw_info', 'web_hook_info', 'url'),
                                        channel: integration.provider_data.dig('raw_info', 'web_hook_info', 'channel'))
  end

  def attachment
    @attachment ||= {
      author_name: send(EVENT_ACTIONS[action]),
      fallback: send(EVENT_ACTIONS[action]),
      color: EVENT_STATUS_COLORS[event.status],
      title: event.title,
      title_link: event_url,
      text: event.message
    }
  end

  def event_url
    @event_url ||= "#{I18n.t("web_url.#{Rails.env}")}/projects/#{event.project.slug}/event/#{event.id}"
  end

  def event_create_notification
    "#{event.title} in #{event.project.name} #{event.environment}."
  end

  def event_update_notification
    "#{reason} pushed #{event.title} from #{previous_status} to #{event.status}."
  end

  def previous_status
    event.saved_changes['status']&.first
  end

  def invalid_webhook?(response)
    ERROR_RESPONSES.any? do |error|
      response.message.include?(error)
    end
  end
end
