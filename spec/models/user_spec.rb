# frozen_string_literal: true

describe User do
  it { should have_many(:project_users).dependent(:destroy) }
  it { should have_many(:projects).through(:project_users) }
end
