# frozen_string_literal: true

describe ProjectSerializer do
  subject { described_class.new(project).as_json }
  let(:project) { create(:project, :with_subscription) }
  let(:serialized_subscription) { SubscriptionSerializer.new(project.subscription).as_json }

  it { is_expected.to have_name(:id).with_value(project.id) }
  it { is_expected.to have_name(:name).with_value(project.name) }
  it { is_expected.to have_name(:description).with_value(project.description) }
  it { is_expected.to have_name(:api_key).with_value(project.api_key) }
  it { is_expected.to have_name(:slug).with_value(project.slug) }
  it { is_expected.to have_name(:active_event_count).with_value(project.active_event_count) }
  it { is_expected.to have_name(:subscription).with_value(serialized_subscription.except(:plan)) }

  context '#stripe_public_key' do
    subject { described_class.new(project, include_stripe_api_key: true).as_json }
    let(:stripe_public_key) { ENV['STRIPE_DEVELOPMENT_PUBLIC_KEY'] }

    it { is_expected.to have_name(:stripe_public_key).with_value(stripe_public_key) }
  end
end
