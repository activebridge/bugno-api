# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }

  context 'should has title and status' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:status) }
  end

  context 'belongs to project and user' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end
end
