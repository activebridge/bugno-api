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
    event.parent? || parent_reactivated?
  end

  def parent_reactivated?
    parent_event.saved_changes[:status] && parent_event.saved_changes[:status] == %w[resolved active]
  end

  def notify
    EventMailer.create(event, emails).deliver_later if email.any?
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
    @event ||= project.events.create(declared_params)
  end

  def parent_event
    @parent_event ||= event.parent
  end

  def emails
    @emails ||= project.users.pluck(:email).compact
  end
end
