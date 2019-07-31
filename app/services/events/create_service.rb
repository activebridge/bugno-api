# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    return [{ message: I18n.t('api.errors.invalid_api_key') }, 401] unless project
    return [{ message: I18n.t('api.errors.subscription_absent') }, 422] if subscription.nil? || expired_subscription

    handle_event_create
  end

  private

  def handle_event_create
    EventMailer.create(event).deliver_later if notify?
    check_parent_status
    Subscription.decrement_counter(:events, subscription.id)
    subscription.expired! if subscription.events <= 1
    [{ message: I18n.t('api.event_captured') }, 201]
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

  def check_parent_status
    parent_event.active! if event.parent_id && parent_event.resolved?
  end

  def notify?
    project && event.persisted? && (event.parent_id.nil? || parent_event.resolved?)
  end
end
