# frozen_string_literal: true

class Transactions::ChargeService < ApplicationService
  CENTS_MULTIPLIER = 100

  def call
    begin
      customer
      charge
    rescue Stripe::StripeError => e
      return e
    end
    user.update_attributes(customer_id: @customer.id)
  end

  private

  def customer
    @customer ||= Stripe::Customer.create(
      source: params[:stripe_token],
      email: user.email
    )
  end

  def charge
    Stripe::Charge.create(
      amount: subscription_price,
      currency: 'usd',
      description: "#{plan.name} plan",
      customer: customer.id
    )
  end

  def plan
    @plan ||= Plan.find(params[:plan_id])
  end

  def subscription_price
    @subscription_price ||= plan.price * CENTS_MULTIPLIER
    @subscription_price.to_i
  end
end
