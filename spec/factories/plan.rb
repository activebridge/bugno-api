# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    name { Faker::App.name }
    description { Faker::Books::Lovecraft.sentence }
    price { Faker::Number.decimal(2) }
  end
end
