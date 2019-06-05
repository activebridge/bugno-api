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

    trait :with_equal_attributes do
      association :project
      association :user
      title { 'NameError' }
      message { 'undefined local variable or method' }
      server_data { { host: 'ancient-pc', root: 'user/my_app' } }
      backtrace do
        [{ filename: 'user/my_app/models/post',
           lineno: 33,
           method: 'class ApplicationRecord',
           code: 'call',
           context: {
             pre: %w[line before code],
             post: %w[line after code]
           } }]
      end
      environment { 'test' }
      ip_address { '127.0.0.1' }
    end
  end
end
