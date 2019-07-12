# frozen_string_literal: true

class Subscriptions::MonthlyChargeService < SubscriptionService
  def call
    ActiveRecord::Base.transaction do
      subscription.update(events: plan.event_limit, expires_at: 1.month.from_now, status: :active)
      charge(subscription, subscription.customer_id)
    rescue Stripe::StripeError => e
      raise ActiveRecord::Rollback if e.is_a?(Stripe::StripeError)
    end
  end

  private

  def plan
    @plan ||= Plan.find(subscription.plan_id)
  end
end
