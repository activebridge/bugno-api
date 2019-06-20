# frozen_string_literal: true

class Subscriptions::CreateService < ApplicationService
  CENTS_MULTIPLIER = 100

  def call
    result = nil
    ActiveRecord::Base.transaction do
      result = project.create_subscription(plan_id: params[:plan_id])
      charge
      user.update(customer_id: @customer.id)
    rescue Stripe::StripeError => e
      result = e
      raise ActiveRecord::Rollback if e.is_a?(Stripe::StripeError)
    end
    result
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  end

  def plan
    @plan ||= Plan.find(params[:plan_id])
  end

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

  def subscription_price
    @subscription_price ||= plan.price * CENTS_MULTIPLIER
    @subscription_price.to_i
  end
end
