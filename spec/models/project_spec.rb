# frozen_string_literal: true

describe Project do
  it { should validate_presence_of(:name) }
  it { should have_many(:project_users).dependent(:destroy) }
  it { should have_many(:users).through(:project_users) }
  it { should have_many(:events).dependent(:delete_all) }
  it { should have_many(:active_events).class_name('Event').conditions(status: :active, parent_id: nil) }
  it { should have_one(:subscription).dependent(:destroy) }
end
