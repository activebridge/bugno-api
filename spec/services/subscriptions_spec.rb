# frozen_string_literal: true

require 'rails_helper'

describe Subscriptions do
  let(:plan) { create(:plan) }
  let(:project) { create(:project) }

  context Subscriptions::CreateService do
    let(:params) do
      { plan_id: plan.id,
        project_id: project.id }
    end

    subject { -> { Subscriptions::CreateService.call(params: params) } }

    it { is_expected.to change(project.subscriptions, :count).by(1) }
  end
end
