# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "#{Faker::App.name}#{n}" }
    description { Faker::Books::Lovecraft.sentence }
    active_event_count { Faker::Number.number(digits: 2) }

    trait :with_subscription do
      after :create do |project|
        create :subscription, project: project
      end
    end
  end
end
