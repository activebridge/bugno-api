# frozen_string_literal: true

class Subscriptions::MonthlyChargeService < ApplicationService
  CENTS_MULTIPLIER = 100

  def call
    result = nil
    ActiveRecord::Base.transaction do
      subscription.update(events: plan.event_limit, expires_at: 1.month.from_now, status: :active)
      charge
    rescue Stripe::StripeError => e
      result = e
      raise ActiveRecord::Rollback if e.is_a?(Stripe::StripeError)
    end
    result
  end

  private

  def customer_id
    @customer_id ||= subscription.customer_id
  end

  def plan
    @plan ||= Plan.find(subscription.plan_id)
  end

  def charge
    Stripe::Charge.create(
      amount: subscription_price,
      currency: 'usd',
      description: "#{plan.name} plan, monthly charge",
      customer: customer_id
    )
  end

  def subscription_price
    @subscription_price ||= plan.price * CENTS_MULTIPLIER
    @subscription_price.to_i
  end
end
