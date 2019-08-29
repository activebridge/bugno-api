# frozen_string_literal: true

FactoryBot.define do
  factory :integration do
    association :project
    type { 'Integration' }
    provider_data { { team: Faker::Lorem.sentence } }

    trait :slack do
      type { 'Integration::Slack' }
      provider_data do
        {
          raw_info: {
            team_info: {
              team: {
                name: Faker::Lorem.word,
                domain: Faker::Lorem.word
              }
            },
            web_hook_info: {
              channel: Faker::Lorem.word
            }
          }
        }
      end
    end
  end
end
