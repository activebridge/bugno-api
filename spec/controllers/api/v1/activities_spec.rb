# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Activities, type: :request do
  let!(:user) { create(:user, :with_projects) }
  let(:project) { user.projects.first }
  let(:valid_params) { attributes_for(:project) }
  let(:base_url) { '/api/v1/activities' }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    let!(:activities) { create_list(:activity, 3, owner: user, recipient: project) }

    subject do
      get(*request_params)
      json
    end

    it { expect(subject['activities'].count).to eq(3) }
    it { expect(subject['total_count']).to eq(3) }
  end
end
