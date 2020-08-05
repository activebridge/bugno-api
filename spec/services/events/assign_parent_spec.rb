# frozen_string_literal: true

describe Events::AssignParentService do
  subject { described_class.call(event: occurrence, project: project) }
  let(:project) { create(:project, :with_subscription) }

  context 'when rails' do
    context 'by backtrace' do
      let!(:event) { create(:event, :static_attributes, project: project) }
      let(:occurrence) { build(:event, :static_attributes, project: project) }
      let(:project_trace) { occurrence.backtrace.find { |trace| trace['project_error'] } }

      it { is_expected.to eq(event.id) }
      it do
        subject
        expect(project_trace).to be_truthy
      end
    end

    context 'by title && message' do
      let(:event) { create(:event, project: project) }
      let(:occurrence) { build(:event, project: project, title: event.title, message: event.message) }

      it { is_expected.to eq(event.id) }
    end
  end

  context 'when javascript' do
    context 'by message' do
      let(:event) { create(:event, project: project, framework: Constants::Event::BROWSER_JS) }
      let(:occurrence) do
        build(:event, project: project, framework: Constants::Event::BROWSER_JS, message: event.message)
      end

      it { is_expected.to eq(event.id) }
    end
  end
end
