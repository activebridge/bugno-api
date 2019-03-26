# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create(:project) }

  context 'should have unique name' do
    it { should validate_presence_of(:name) }
  end

  context 'should destroy entries in project_users table with foreign key' do
    it { expect(project).to have_many(:project_users).dependent(:destroy) }
  end
end
