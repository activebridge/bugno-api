# frozen_string_literal: true

class Subscriptions::UpdateService < ApplicationService
  CENTS_MULTIPLIER = 100

  def call
    result = subscription
    ActiveRecord::Base.transaction do
      subscription.update(plan_id: plan.id, events: events, status: :active,
                          expires_at: 1.month.from_now, customer_id: customer_id)
      charge
    rescue Stripe::StripeError => e
      result = e
      raise ActiveRecord::Rollback if e.is_a?(Stripe::StripeError)
    end
    result
  end

  private

  def subscription
    @subscription ||= Subscription.find(params[:id])
  end

  def plan
    @plan ||= Plan.find(params[:plan_id])
  end

  def events
    @events ||= plan.event_limit + subscription.events
  end

  def customer_id
    @customer_id ||= Stripe::Customer.update(
      subscription.customer_id,
      email: user.email,
      source: params[:stripe_source]
    ).id
  end

  def charge
    Stripe::Charge.create(
      amount: subscription_price,
      currency: 'usd',
      description: "#{plan.name} plan",
      customer: customer_id
    )
  end

  def subscription_price
    @subscription_price ||= plan.price * CENTS_MULTIPLIER
    @subscription_price.to_i
  end
end
