# frozen_string_literal: true

Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_DEVELOPMENT_PUBLIC_KEY'],
  secret_key: ENV['STRIPE_DEVELOPMENT_SECRET_KEY']
}

Stripe.api_key = ENV['STRIPE_DEVELOPMENT_SECRET_KEY']
