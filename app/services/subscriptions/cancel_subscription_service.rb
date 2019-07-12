# frozen_string_literal: true

class Subscriptions::CancelSubscriptionService < ApplicationService
  def call
    return unless card_id

    Stripe::Customer.delete_source(customer_id, card_id)
    subscription.update(plan_id: nil)
    subscription
  end

  private

  def subscription
    @subscription ||= Subscription.find(params[:id])
  end

  def customer_id
    @customer_id ||= subscription.customer_id
  end

  def card_id
    @card_id ||= Stripe::Customer.retrieve(customer_id).sources&.first&.id
  end
end
