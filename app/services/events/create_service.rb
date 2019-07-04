# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    return [{ message: I18n.t('api.errors.invalid_api_key') }, 401] unless project
    return [{ message: I18n.t('api.errors.subscription_absent') }, 422] if subscription.nil? || expired_subscription

    handle_event_create
  end

  private

  def handle_event_create
    EventMailer.create(event).deliver_later if project && event.persisted?
    Subscription.decrement_counter(:events, subscription.id)
    [{ message: I18n.t('api.event_captured') }, 201]
  end

  def expired_subscription
    subscription.expired? || subscription.events.negative?
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
end
