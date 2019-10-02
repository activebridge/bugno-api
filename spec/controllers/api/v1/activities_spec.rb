# frozen_string_literal: true

describe API::V1::Activities do
  let!(:user) { create(:user, :with_project_and_subscription) }
  let(:project) { user.projects.first }
  let(:base_url) { '/api/v1/activities' }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  describe '#index' do
    subject { -> { get(*request_params) } }
    let!(:activities) { create_list(:activity, 3, owner: user, recipient: project) }

    it { is_expected.to respond_with_json_count(3).at(:activities) }
    it { is_expected.to respond_with_json(3, :total_count) }
  end
end
