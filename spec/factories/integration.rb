# frozen_string_literal: true

FactoryBot.define do
  factory :integration do
    association :project
    type { Faker::Lorem.word }
    provider_data { { team: Faker::Lorem.sentence } }

    trait :slack do
      provider_data do
        {
          raw_info: {
            url: Faker::Internet.url,
            team: Faker::Lorem.word
          },
          web_hook_info: {
            url: Faker::Internet.url,
            channel: Faker::Lorem.word
          }
        }
      end
    end
  end
end
