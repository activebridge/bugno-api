# frozen_string_literal: true

describe PlanSerializer do
  subject { described_class.new(plan).as_json }
  let(:plan) { create(:plan) }

  it { is_expected.to have_name(:id).with_value(plan.id) }
  it { is_expected.to have_name(:description).with_value(plan.description) }
  it { is_expected.to have_name(:price).with_value(plan.price) }
  it { is_expected.to have_name(:event_limit).with_value(plan.event_limit) }
end
