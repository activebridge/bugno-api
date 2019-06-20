# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    association :plan
    expires_at { Faker::Date.between(1.year.ago, 1.year.from_now) }
    events { Faker::Number.number(3) }
  end
end
