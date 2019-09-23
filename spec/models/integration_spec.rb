# frozen_string_literal: true

describe Integration do
  it { should belong_to(:project) }
  it { should delegate_method(:user_owner?).to(:project).with_prefix.allow_nil }
end
