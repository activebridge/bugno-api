# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { create(:user) }

  subject do
    described_class.new(user).as_json
  end

  it { is_expected.to include(id: user.id, image: user.image, email: user.email) }
end
