# frozen_string_literal: true

describe Subscription do
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:expires_at) }
  it { should belong_to(:project) }
  it { should belong_to(:plan).optional }
  it { should delegate_method(:name).to(:plan).with_prefix.allow_nil }
  it { should delegate_method(:cent_price).to(:plan).with_prefix.allow_nil }
end
