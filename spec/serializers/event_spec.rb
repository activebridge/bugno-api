# frozen_string_literal: true

describe EventSerializer do
  subject { described_class.new(event).as_json }
  let(:event) { create(:event) }

  it { is_expected.to have_name(:id).with_value(event.id) }
  it { is_expected.to have_name(:title).with_value(event.title) }
  it { is_expected.to have_name(:environment).with_value(event.environment) }
  it { is_expected.to have_name(:status).with_value(event.status) }
  it { is_expected.to have_name(:user_id).with_value(event.user_id) }
  it { is_expected.to have_name(:project_id).with_value(event.project_id) }
  it { is_expected.to have_name(:message).with_value(event.message) }
  it { is_expected.to have_name(:backtrace).with_value(event.backtrace) }
  it { is_expected.to have_name(:framework).with_value(event.framework) }
  it { is_expected.to have_name(:url).with_value(event.url) }
  it { is_expected.to have_name(:ip_address).with_value(event.ip_address) }
  it { is_expected.to have_name(:headers).with_value(event.headers) }
  it { is_expected.to have_name(:http_method).with_value(event.http_method) }
  it { is_expected.to have_name(:params).with_value(event.params) }
  it { is_expected.to have_name(:position).with_value(event.position) }
  it { is_expected.to have_name(:server_data).with_value(event.server_data) }
  it { is_expected.to have_name(:background_data).with_value(event.background_data) }
  it { is_expected.to have_name(:last_occurrence_at).with_value(event.last_occurrence_at) }

  context '#user_agent' do
    let(:event) { create(:event, :static_attributes) }

    it { is_expected.to have_name(:user_agent) }
  end
end
