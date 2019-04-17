# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::App.name }
    api_key { SecureRandom.urlsafe_base64(nil, false) }
    description { Faker::Books::Lovecraft.sentence }

    before(:create) do |project|
      create(:project_user, project: project)
    end
  end
end
