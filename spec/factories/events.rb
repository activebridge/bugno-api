# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association :project
    association :user
    title { Faker::Food.fruits }
    environment { ActiveRecord::Base.configurations.keys.sample }
    status { Event.statuses.values.sample }
    trait :active do
      status { :active }
    end
  end
end
