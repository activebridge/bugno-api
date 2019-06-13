# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    return if missing_subscription

    handle_event_create
  end

  private

  def handle_event_create
    EventMailer.create(event).deliver_later if project && event.persisted?
    Subscription.decrement_counter(:events, subscription.id)
  end

  def missing_subscription
    subscription.status == 'expired' || subscription.events.negative?
  end

  def project
    @project ||= Project.find_by(api_key: declared_params[:project_id])
  end

  def event
    @event ||= project.events.create(declared_params)
  end

  def subscription
    @subscription ||= project&.subscription
  end
end
