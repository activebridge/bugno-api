# frozen_string_literal: true

describe Activity::CollectionSerializer do
  subject { described_class.new(PublicActivity::Activity.page).as_json }
  let!(:activities) { create_list(:activity, 3) }

  it { is_expected.to have_name(:total_count).with_value(3) }
end
