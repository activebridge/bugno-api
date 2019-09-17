# frozen_string_literal: true

describe Event do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:framework) }
  it { should belong_to(:project) }
  it { should belong_to(:user).optional }
  it { should belong_to(:parent).class_name('Event').counter_cache(:occurrence_count).optional }
  it { should have_many(:occurrences).class_name('Event').with_foreign_key('parent_id') }

  describe '#created_at=' do
    subject { Event.create(params).created_at.to_i }
    let(:params) { attributes_for(:event, created_at: 10.minutes.ago.to_i) }

    context 'when params passed' do
      it 'overrides timestamp' do
        is_expected.to eq(params[:created_at])
      end
    end
  end

  describe '#message=' do
    subject { Event.create(params).message.length }
    let(:params) { attributes_for(:event, message: 'q' * 3100) }

    it { is_expected.to be <= 3000 }
  end

  describe '#user_agent?' do
    subject { event.user_agent? }
    let(:event) { create(:event, :static_attributes) }

    context 'when User-Agent header present' do
      it { is_expected.to be_truthy }
    end

    context 'when header missing' do
      let(:event) { create(:event, headers: nil) }

      it { is_expected.to be_falsy }
    end
  end

  describe '#parent?' do
    subject { event.parent? }
    let(:event) { create(:event, parent_id: nil) }

    context 'when parent_id is nil' do
      it { is_expected.to be_truthy }
    end
  end
end
