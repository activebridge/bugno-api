# frozen_string_literal: true

describe ProjectUserSerializer do
  subject { described_class.new(project_user).as_json }
  let(:project_user) { create(:project_user) }
  let(:serialized_user) { UserSerializer.new(project_user.user).as_json }

  it { is_expected.to have_name(:id).with_value(project_user.id) }
  it { is_expected.to have_name(:project_id).with_value(project_user.project_id) }
  it { is_expected.to have_name(:user_id).with_value(project_user.user_id) }
  it { is_expected.to have_name(:role).with_value(project_user.role) }
  it { is_expected.to have_name(:user).with_value(serialized_user) }
end
