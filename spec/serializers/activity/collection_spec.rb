# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Activity::CollectionSerializer do
  let!(:activities) { create_list(:activity, 3) }

  subject do
    described_class.new(PublicActivity::Activity.page).as_json
  end

  it { is_expected.to include(total_count: 3) }
end
