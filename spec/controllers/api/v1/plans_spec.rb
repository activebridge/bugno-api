# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Plans, type: :request do
  let!(:plans) { create_list(:plan, 3) }
  let(:base_url) { '/api/v1/plans' }
  let(:url) { base_url }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    subject do
      get(*request_params)
      json.count
    end

    it { is_expected.to eq(plans.count) }
  end
end
