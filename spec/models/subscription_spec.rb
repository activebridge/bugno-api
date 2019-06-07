# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { create(:subscription) }

  context 'validates presence' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:expires_at) }
  end

  context 'associations' do
    it { expect(subscription).to have_and_belong_to_many(:projects) }
  end
end
