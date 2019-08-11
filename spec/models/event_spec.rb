# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:framework) }
  it { should belong_to(:project) }
  it { should belong_to(:user).optional }
  it { should belong_to(:parent).class_name('Event').counter_cache(:occurrence_count).optional }
  it { should have_many(:occurrences).class_name('Event').with_foreign_key('parent_id') }
end
