# frozen_string_literal: true

FactoryBot.define do
  factory :project_user do
    association :user
    association :project

    trait :with_subscription do
      association :project, :with_subscription
    end
  end
end
