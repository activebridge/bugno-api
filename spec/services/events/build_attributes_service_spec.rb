# frozen_string_literal: true

describe Events::BuildAttributesService do
  subject { described_class.call(params: params, project: project) }
  let(:project) { create(:project, :with_subscription) }

  context 'when rails' do
    context 'by backtrace' do
      let!(:event) { create(:event, :static_attributes, :with_project_error_trace, project: project) }
      let(:params) { attributes_for(:event, :static_attributes).as_json }
      let(:project_trace) { subject['backtrace'].find { |trace| trace['project_error'] } }

      it { is_expected.to include(parent_id: event.id) }
      it do
        subject
        expect(project_trace).to be_truthy
      end
    end

    context 'by title && message' do
      let(:event) { create(:event, project: project) }
      let(:params) { attributes_for(:event, title: event.title, message: event.message).as_json }

      it { is_expected.to include(parent_id: event.id) }

      context 'when messages are similar' do
        let(:event) do
          create(
            :event, project: project,
                    message: '`identify -format %[orientation] /tmp/ActiveStorage20200911-6277-16hdqlp.png[0]`'
          )
        end
        let(:params) do
          attributes_for(
            :event, title: event.title,
                    message: '`identify -format %[orientation] /tmp/ActiveStorage20200911-6277-1x55pi4.png[0]`'
          ).as_json
        end

        it { is_expected.to include(parent_id: event.id) }
      end
    end
  end

  context 'when javascript' do
    context 'by message' do
      let(:event) { create(:event, project: project, framework: Constants::Event::BROWSER_JS) }
      let(:params) { attributes_for(:event, framework: Constants::Event::BROWSER_JS, message: event.message).as_json }

      it { is_expected.to include(parent_id: event.id) }
    end
  end
end
