# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { create(:user) }

  subject do
    serialized_user = UserSerializer.new(user).serializable_hash
    data_attributes(serialized_user)
  end

  it { is_expected.to include(id: user.id, name: user.name, email: user.email) }
end
