# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    association :project, :with_subscription
    association :user
    title { Faker::Lorem.word }
    framework { 'rails' }
    message { Faker::Lorem.sentence }
    server_data { { host: Faker::Lorem.word, root: Faker::Lorem.word } }
    backtrace do
      [{ filename: Faker::Lorem.sentence,
         lineno: Faker::Number.number(digits: 3),
         method: Faker::Lorem.word,
         code: Faker::Lorem.sentence,
         context: {
           pre: Faker::Lorem.sentences(number: 4),
           post: Faker::Lorem.sentences(number: 4)
         } }]
    end
    url { Faker::Internet.url }
    http_method { 'POST' }
    headers { { Faker::Lorem.word => Faker::Lorem.sentence } }
    person_data do
      { id: Faker::Number.number(digits: 1),
        email: Faker::Internet.email,
        username: Faker::Internet.username }
    end
    # TODO: generate real environment names
    environment { Faker::Lorem.word }
    ip_address { Faker::Internet.ip_v4_address }
    last_occurrence_at { 10.minutes.ago }

    trait :static_attributes do
      association :project, :with_subscription
      association :user
      title { 'NameError' }
      framework { 'rails' }
      message { 'undefined local variable or method' }
      server_data { { host: 'ancient-pc', root: 'user/my_app' } }
      backtrace do
        [{ filename: 'user/my_app/models/post',
           lineno: '33',
           method: 'class ApplicationRecord',
           code: 'call',
           context: {
             pre: %w[line before code],
             post: %w[line after code]
           } }]
      end
      environment { 'test' }
      ip_address { '127.0.0.1' }
      headers do
        { 'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) \
                        AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36' }
      end
      person_data { nil }
      url { 'http://localhost:3000' }
      http_method { 'POST' }
      last_occurrence_at { 1.hour.ago }
    end
  end
end
