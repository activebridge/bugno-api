# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    sequence(:name) { |n| "#{Faker::App.name}#{n}" }
    description { Faker::Books::Lovecraft.sentence }
    price { Faker::Number.decimal(l_digits: 2) }
    event_limit { Faker::Number.number(digits: 5) }
  end
end
