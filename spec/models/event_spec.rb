# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:framework) }
  it { should belong_to(:project) }
  it { should belong_to(:user).optional }
  it { should belong_to(:parent).class_name('Event').counter_cache(:occurrence_count).optional }
  it { should have_many(:occurrences).class_name('Event').with_foreign_key('parent_id') }

  context 'created_at should be overwritten with timestamp from params' do
    let(:params) { attributes_for(:event, created_at: 10.minutes.ago.to_i) }

    subject { Event.create(params).created_at.to_i }

    it { is_expected.to eq(params[:created_at]) }
  end

  context 'truncate message to less than three thousand' do
    let(:params) { attributes_for(:event, message: 'q' * 3100) }

    subject { Event.create(params).message.length }

    it { is_expected.to be <= 3000 }
  end

  context 'user_agent?' do
    let(:event) { create(:event, :with_equal_attributes) }

    subject { event.user_agent? }

    it { is_expected.to be_truthy }

    context 'false' do
      let(:event) { create(:event, headers: nil) }

      it { is_expected.to be_falsy }
    end
  end
end
