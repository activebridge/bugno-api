# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectUserSerializer do
  let(:project_user) { create(:project_user) }
  let(:user) { project_user.user }

  subject do
    serialized_project_user = ProjectUserSerializer.new(project_user).serializable_hash
    data_attributes(serialized_project_user)
  end
  it {
    is_expected.to include(id: project_user.id, project_id: project_user.project_id, user_id: project_user.user_id,
                           role: project_user.role)
  }
  context 'user attribute' do
    subject do
      serialized_project_user = ProjectUserSerializer.new(project_user).serializable_hash
      data_attributes(serialized_project_user)[:user][:data][:attributes]
    end
    it { is_expected.to include(id: user.id, name: user.name, email: user.email) }
  end
end
