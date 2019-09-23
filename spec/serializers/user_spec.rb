# frozen_string_literal: true

describe UserSerializer do
  subject { described_class.new(user).as_json }
  let(:user) { create(:user) }
  let(:action_cable_token) { SecureRandom.urlsafe_base64(nil, false) }

  before { allow_any_instance_of(described_class).to receive(:action_cable_token).and_return(action_cable_token) }

  it { is_expected.to have_name(:id).with_value(user.id) }
  it { is_expected.to have_name(:nickname).with_value(user.nickname) }
  it { is_expected.to have_name(:image).with_value(user.image) }
  it { is_expected.to have_name(:email).with_value(user.email) }
  it { is_expected.to have_name(:action_cable_token).with_value(action_cable_token) }
end
