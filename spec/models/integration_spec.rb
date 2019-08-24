# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Integration, type: :model do
  it { should belong_to(:project) }
  it { should delegate_method(:user_owner?).to(:project).with_prefix.allow_nil }
end
