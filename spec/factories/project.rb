# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "#{Faker::App.name}#{n}" }
    api_key { SecureRandom.urlsafe_base64(nil, false) }
    description { Faker::Books::Lovecraft.sentence }
  end
end
