# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectUserSerializer do
  let(:project_user) { create(:project_user) }
  let(:user) { project_user.user }

  subject do
    described_class.new(project_user).as_json
  end
  it {
    is_expected.to include(id: project_user.id, project_id: project_user.project_id, user_id: project_user.user_id,
                           role: project_user.role)
  }
  context 'user attribute' do
    subject do
      described_class.new(project_user).as_json[:user]
    end
    it { is_expected.to include(id: user.id, name: user.name, email: user.email) }
  end
end
