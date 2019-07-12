# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    association :plan
    expires_at { 1.month.from_now }

    trait :expired do
      expires_at { 1.month.ago }
      status { :expired }
      after :create do |subscription|
        subscription.events = 0
      end
    end
  end
end
