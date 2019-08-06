# frozen_string_literal: true

FactoryBot.define do
  factory :activity, class: 'PublicActivity::Activity' do
    association :owner, factory: :user
    association :trackable, factory: :event
    association :recipient, factory: :project
  end
end
