# frozen_string_literal: true

describe Plan do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:subscriptions).dependent(:destroy) }
end
