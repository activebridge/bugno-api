# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association :project
    association :user
    title { Faker::Lorem.word }
    message { Faker::Lorem.sentence }
    server_data { { host: Faker::Lorem.word, root: Faker::Lorem.word } }
    backtrace do
      [{ filename: Faker::Lorem.sentence,
         lineno: Faker::Number.number(3),
         method: Faker::Lorem.word,
         code: Faker::Lorem.sentence,
         context: {
           pre: Faker::Lorem.sentences(4),
           post: Faker::Lorem.sentences(4)
         } }]
    end
    environment { ActiveRecord::Base.configurations.keys.sample }
    ip_address { Faker::Internet.ip_v4_address }
  end
end
