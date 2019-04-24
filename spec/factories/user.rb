# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email     { Faker::Internet.email }
    password  { Faker::Internet.password }

    trait :with_projects do
      after(:create) do |user|
        create(:project_user, user: user)
      end
    end

    trait :with_projects_as_collaborator do
      after(:create) do |user|
        create(:project_user, user: user, role: 'collaborator')
      end
    end
  end
end
