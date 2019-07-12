# frozen_string_literal: true

class Subscriptions::UpdateService < SubscriptionService
  def call
    result = subscription
    ActiveRecord::Base.transaction do
      update_subscription
      charge(subscription, customer_id)
    rescue Stripe::StripeError => e
      result = e
      raise ActiveRecord::Rollback if e.is_a?(Stripe::StripeError)
    end
    result
  end

  private

  def events
    plan.event_limit + subscription.events
  end

  def update_subscription
    subscription.update(plan_id: params[:plan_id], events: events,
                        status: :active, expires_at: 1.month.from_now, customer_id: customer_id)
  end

  def plan
    @plan ||= Plan.find(params[:plan_id])
  end

  def subscription
    @subscription ||= Subscription.find(params[:id])
  end

  def customer_id
    @customer_id ||= Stripe::Customer.update(
      subscription.customer_id,
      email: user.email,
      source: params[:stripe_source]
    ).id
  end
end
