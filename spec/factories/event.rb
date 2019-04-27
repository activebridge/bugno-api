# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association :project
    association :user
    title { Faker::Lorem.word }
    message { Faker::Lorem.sentence }
    server_data { { host: Faker::Lorem.word, root: Faker::Lorem.word } }
    backtrace { Faker::Lorem.sentences(5) }
    environment { ActiveRecord::Base.configurations.keys.sample }
    ip_address { Faker::Internet.ip_v4_address }
  end
end
