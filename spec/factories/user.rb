# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email     { Faker::Internet.unique.email }
    name      { Faker::Name.name }
    password  { Faker::Internet.password }

    trait :with_project do
      after(:create) do |user|
        create(:project_user, user: user)
      end
    end

    trait :with_project_and_subscription do
      after(:create) do |user|
        create(:project_user, :with_subscription, user: user)
      end
    end

    trait :with_project_as_collaborator do
      after(:create) do |user|
        create(:project_user, user: user, role: 'collaborator')
      end
    end
  end
end
