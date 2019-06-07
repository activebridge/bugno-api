# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plan, type: :model do
  context 'validates presence' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:price) }
  end

  context 'validates uniqueness' do
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:description) }
  end
end
