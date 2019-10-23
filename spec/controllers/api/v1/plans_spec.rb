# frozen_string_literal: true

describe Api::V1::Plans do
  let(:base_url) { '/api/v1/plans' }
  let(:url) { base_url }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  describe '#index' do
    subject { -> { get(*request_params) } }
    let!(:plans) { create_list(:plan, 3) }

    it { is_expected.to respond_with_status(200) }
    it { is_expected.to respond_with_json_count(3) }
  end
end
