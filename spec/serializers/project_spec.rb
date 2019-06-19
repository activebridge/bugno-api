# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectSerializer do
  let(:project) { create(:project) }

  subject do
    described_class.new(project).as_json
  end

  it {
    is_expected.to include(id: project.id, name: project.name, description: project.description,
                           api_key: project.api_key)
  }
end
