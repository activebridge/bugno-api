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
    let(:event) { build(:event, :static_attributes) }

    context 'when User-Agent header present' do
      it { is_expected.to be_truthy }
    end

    context 'when header missing' do
      let(:event) { build(:event, headers: nil) }

      it { is_expected.to be_falsy }
    end
  end

  describe '#parent?' do
    subject { event.parent? }
    let(:event) { build(:event, parent_id: nil) }

    context 'when parent_id is nil' do
      it { is_expected.to be_truthy }
    end
  end

  describe '#occurrence?' do
    subject { event.occurrence? }
    let(:event) { build(:event, parent_id: 1) }

    context 'when parent_id is present' do
      it { is_expected.to be_truthy }
    end
  end

  context 'after save' do
    subject { -> { event.save } }
    let(:project) { create(:project, :with_subscription) }

    describe '#update_active_count' do
      let(:event) { build(:event, project: project) }

      context 'when event is parent' do
        it { is_expected.to change(project.reload, :active_event_count) }
      end

      context 'when event is occurrence' do
        let(:parent) { create(:event, project: project) }
        let(:event) { build(:event, project: project, parent_id: parent.id) }

        it { is_expected.to change(project.reload, :active_event_count).from(0).to(1) }
      end
    end

    context do
      let(:parent) { create(:event, project: project, status: :resolved) }
      let(:event) { build(:event, project: project, parent_id: parent.id) }

      describe '#reactivate_parent' do
        it { is_expected.to change { parent.reload.status }.from('resolved').to('active') }
      end

      describe '#update_occurrence_at' do
        let(:parent) { create(:event, project: project, last_occurrence_at: nil) }

        it { is_expected.to change { parent.reload.last_occurrence_at } }
      end

      describe '#update_subscription_events' do
        it { is_expected.to change { project.subscription.reload.events }.by(-2) }
      end
    end
  end

  context do
    subject { -> { parent.update(status: new_status) } }
    let(:project) { create(:project, :with_subscription) }
    let(:parent) { create(:event, project: project) }
    let(:event) { create(:event, project: project, parent_id: parent.id) }
    let(:new_status) { 'resolved' }

    describe '#update_occurrences_status' do
      it { is_expected.to change { event.reload.status }.to('resolved') }
    end
  end
end
