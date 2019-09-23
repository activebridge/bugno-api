# frozen_string_literal: true

describe Activity::SingleSerializer do
  subject { described_class.new(activity).as_json }
  let(:activity) { create(:activity) }
  let(:owner) { Activity::UserSerializer.new(activity.owner).as_json }
  let(:trackable) { Activity::EventSerializer.new(activity.trackable).as_json }
  let(:recipient) { Activity::ProjectSerializer.new(activity.recipient).as_json }

  it { is_expected.to have_name(:parameters).with_value(activity.parameters) }
  it { is_expected.to have_name(:created_at).with_value(activity.created_at) }
  it { is_expected.to have_name(:owner_type).with_value(activity.owner_type) }
  it { is_expected.to have_name(:trackable_type).with_value(activity.trackable_type) }
  it { is_expected.to have_name(:recipient_type).with_value(activity.recipient_type) }
  it { is_expected.to have_name(:owner).with_value(owner) }
  it { is_expected.to have_name(:recipient).with_value(recipient) }
  it { is_expected.to have_name(:trackable).with_value(trackable) }
end
