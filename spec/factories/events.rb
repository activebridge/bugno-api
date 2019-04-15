# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association :project
    association :user
    title { Faker::Food.fruits }
    environment { ActiveRecord::Base.configurations.keys.sample }
    status { 'active' }
    ip_address { Faker::Internet.ip_v4_address }
  end
end
