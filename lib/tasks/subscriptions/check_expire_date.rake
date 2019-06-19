# frozen_string_literal: true

namespace :subscriptions do
  task check_expire_date: :environment do
    Subscription.all.each do |subscription|
      subscription.expired! if subscription.expires_at <= Time.now
    end
  end
end
