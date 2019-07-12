# frozen_string_literal: true

namespace :subscriptions do
  task monthly_charge: :environment do
    Subscription.by_expired.find_each do |subscription|
      subscription.expired! if subscription.active?
      ::Subscriptions::MonthlyChargeService.call(subscription: subscription) if subscription.customer_id
    end
  end
end
