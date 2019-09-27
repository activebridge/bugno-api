# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "#{Faker::App.name}#{n}" }
    description { Faker::Books::Lovecraft.sentence }

    trait :with_subscription do
      after(:create) do |project|
        create(:subscription, project: project)
      end
    end
  end
end
