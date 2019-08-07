# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create(:project) }

  context 'name presence' do
    it { should validate_presence_of(:name) }
  end

  context 'associations' do
    it { expect(project).to have_many(:project_users).dependent(:destroy) }
    it { expect(project).to have_many(:events).dependent(:delete_all) }
    it { expect(project).to have_one(:subscription) }
  end
end
