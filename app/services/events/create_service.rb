# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    return [{ error: I18n.t('api.errors.invalid_api_key') }, 401] unless project
    return event unless event.persisted?

    notify if notify?
    [{ message: I18n.t('api.event_captured') }, 201]
  end

  private

  def notify?
    event.parent? || occurred_again?
  end

  def occurred_again?
    Constants::Rules::OCCURRENCE_NOTIFICATION_POINTS.any? { |point| point == parent_event&.occurrence_count }
  end

  def notify
    mailer = event.parent? ? :exception : :occurrence
    EventMailer.send(mailer, event, user_emails).deliver_later
    Integration.notify(notify_attributes)
  end

  def notify_attributes
    return { event: event, action: UserChannel::ACTIONS::CREATE_EVENT, reason: nil } if event.parent?

    { event: parent_event, action: UserChannel::ACTIONS::UPDATE_EVENT, reason: 'Occurrence' }
  end

  def project
    @project ||= Project.find_by(api_key: declared_params[:project_id])
  end

  def event
    @event ||= begin
      project.with_lock do
        project.events.create(declared_params)
      end
    end
  end

  def parent_event
    @parent_event ||= event.parent
  end

  def user_emails
    @user_emails ||= project.users.pluck(:email)
  end
end
