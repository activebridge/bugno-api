# frozen_string_literal: true

describe SubscriptionSerializer do
  subject { described_class.new(subscription).as_json }
  let(:subscription) { create(:subscription) }
  let(:serialized_plan) { PlanSerializer.new(subscription.plan).as_json }

  it { is_expected.to have_name(:id).with_value(subscription.id) }
  it { is_expected.to have_name(:plan_id).with_value(subscription.plan_id) }
  it { is_expected.to have_name(:expires_at).with_value(subscription.expires_at) }
  it { is_expected.to have_name(:status).with_value(subscription.status) }
  it { is_expected.to have_name(:events).with_value(subscription.events) }
  it { is_expected.to have_name(:updated_at).with_value(subscription.updated_at) }
  it { is_expected.to have_name(:plan).with_value(serialized_plan) }
end
