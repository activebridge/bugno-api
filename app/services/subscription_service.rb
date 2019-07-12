# frozen_string_literal: true

class SubscriptionService < ApplicationService
  def charge(subscription, customer_id)
    Stripe::Charge.create(
      amount: subscription.plan_cent_price,
      currency: 'usd',
      description: "#{subscription.plan_name} plan",
      customer: customer_id
    )
  end
end
