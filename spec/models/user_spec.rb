# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:project_users).dependent(:destroy) }
  it { should have_many(:projects).through(:project_users) }
  it { should have_many(:project_activities).through(:projects).source(:activities) }
end
