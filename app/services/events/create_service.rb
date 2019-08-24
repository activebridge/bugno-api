# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    return [{ message: I18n.t('api.errors.invalid_api_key') }, 401] unless project
    return [{ message: I18n.t('api.errors.subscription_absent') }, 403] if subscription.nil? || expired_subscription

    handle_event_create
  end

  private

  def handle_event_create
    return [{ message: 'Event was not captured due unprocessable entity' }, 422] unless event.persisted?

    notify if notify?
    update_subscription
    [{ message: I18n.t('api.event_captured') }, 201]
  end

  def notify?
    event.persisted? && (event.parent? || parent_event.resolved?)
  end

  def notify
    update_parent_event if parent_event&.resolved?
    EventMailer.create(event).deliver_later
    project.integrations.find_each { |integration| integration.notify(*notify_attributes) }
  end

  def notify_attributes
    return [UserChannel::ACTIONS::CREATE_EVENT, nil, event] if event.parent?

    [UserChannel::ACTIONS::UPDATE_EVENT, 'Occurrence', parent_event]
  end

  def update_subscription
    Subscription.decrement_counter(:events, subscription.id)
    subscription.expired! if subscription.events <= 1
  end

  def expired_subscription
    subscription.expired? || !subscription.events.positive?
  end

  def project
    @project ||= Project.find_by(api_key: declared_params[:project_id])
  end

  def event
    @event ||= project.events.create(declared_params)
  end

  def subscription
    @subscription ||= project.subscription
  end

  def parent_event
    @parent_event ||= event.parent
  end

  def update_parent_event
    parent_event.active!
    parent_event.occurrences.update_all(status: :active)
    create_activity
  end

  def create_activity
    parent_event.create_activity(:update, owner: event,
                                          recipient: project,
                                          params: { status: { previous: parent_event.saved_changes['status'].first,
                                                              new: parent_event.saved_changes['status'].last } })
  end
end
