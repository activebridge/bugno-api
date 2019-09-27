# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    return [{ error: I18n.t('api.errors.invalid_api_key') }, 401] unless project

    handle_event_create
  end

  private

  def handle_event_create
    return event unless event.persisted?

    notify if notify?
    [{ message: I18n.t('api.event_captured') }, 201]
  end

  def notify?
    event.persisted? && (event.parent? || parent_event.resolved?)
  end

  def notify
    EventMailer.create(event).deliver_later
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
end
