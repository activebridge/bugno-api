# frozen_string_literal: true

require 'rails_helper'

describe API::V1::Base::Projects, type: :request do
  let!(:user) { create(:user) }
  let(:valid_params) { attributes_for(:project) }
  let(:base_url) { '/api/v1/projects' }
  let(:url) { base_url }
  let(:headers) { user.create_new_auth_token }
  let(:params) { {} }
  let(:request_params) { [url, { params: params, headers: headers }] }

  context '#index' do
    let!(:project_users) { create_list(:project_user, 3, user: user) }

    subject do
      get(*request_params)
      json['data'].count
    end

    it { is_expected.to eq(project_users.count) }
  end

  context '#create' do
    let(:params) { { project: valid_params } }

    subject { -> { post(*request_params) } }

    it { is_expected.to change(user.projects, :count).by(1) }

    context 'with invalid params' do
      let(:params) { { project: { name: nil } } }

      it { is_expected.not_to change(user.projects, :count) }
    end
  end

  context '#show' do
    let!(:project_user) { create(:project_user, user: user) }
    let(:url) { "#{base_url}/#{project_user.project_id}" }

    subject do
      get(*request_params)
      response.body
    end

    it { is_expected.to eq(ProjectSerializer.new(project_user.project).serialized_json) }
  end

  context '#update' do
    let!(:project_user) { create(:project_user, user: user) }
    let(:project) { project_user.project }
    let(:params) { { project: valid_params } }
    let(:url) { "#{base_url}/#{project.id}" }

    subject { -> { patch(*request_params) } }

    it { is_expected.to change { project.reload.attributes } }
  end

  context '#destroy' do
    let!(:project_user) { create(:project_user, user: user) }
    let(:url) { "#{base_url}/#{project_user.project_id}" }
    let(:params) { { id: project_user.project_id } }

    subject { -> { delete(*request_params) } }

    it { is_expected.to change(user.projects, :count).by(-1) }
  end
end
