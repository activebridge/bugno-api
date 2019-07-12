# frozen_string_literal: true

class Subscriptions::CreateService < SubscriptionService
  def call
    subscription = nil
    ActiveRecord::Base.transaction do
      subscription = project.create_subscription(plan_id: params[:plan_id], customer_id: customer_id)
      charge(subscription, customer_id)
    rescue Stripe::StripeError => e
      subscription = e
      raise ActiveRecord::Rollback if e.is_a?(Stripe::StripeError)
    end
    subscription
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  end

  def customer_id
    @customer_id ||= Stripe::Customer.create(
      source: params[:stripe_source],
      email: user.email
    ).id
  end
end
