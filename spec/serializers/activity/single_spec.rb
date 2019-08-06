# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Activity::SingleSerializer do
  let(:activity) { create(:activity) }
  let(:owner) { Activity::UserSerializer.new(activity.owner).as_json }
  let(:trackable) { Activity::EventSerializer.new(activity.trackable).as_json }
  let(:recipient) { Activity::ProjectSerializer.new(activity.recipient).as_json }

  subject do
    described_class.new(activity).as_json
  end

  it { is_expected.to include(:owner, :trackable, :recipient) }

  it { expect(subject[:owner].as_json).to eq(owner) }
  it { expect(subject[:trackable].as_json).to eq(trackable) }
  it { expect(subject[:recipient].as_json).to eq(recipient) }
end
