# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:project) { create(:project) }
  let(:subscription) { create(:subscription, project_id: project.id) }

  context 'validates presence' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:expires_at) }
  end

  context 'associations' do
    it { expect(subscription).to belong_to(:project) }
  end
end
