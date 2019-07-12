# frozen_string_literal: true

class Subscriptions::CancelSubscriptionService < SubscriptionService
  def call
    return unless card_id

    Stripe::Customer.delete_source(subscription.customer_id, card_id)
    subscription.update(plan_id: nil)
    subscription
  end

  private

  def subscription
    @subscription ||= Subscription.find(params[:id])
  end

  def card_id
    @card_id ||= Stripe::Customer.retrieve(subscription.customer_id).default_source
  end
end
