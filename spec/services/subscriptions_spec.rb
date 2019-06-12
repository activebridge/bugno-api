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

    subject do
      Subscriptions::CreateService.call(params: params)
      project.subscription
    end

    it { is_expected.not_to be_nil }
  end
end
