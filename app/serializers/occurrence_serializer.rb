# frozen_string_literal: true

class OccurrenceSerializer < ApplicationSerializer
  attributes :id, :title, :project_id, :message, :created_at, :parent_id
  attribute :user_agent, if: proc { object.user_agent? }

  def user_agent
    DeviceDetectorSerializer.new(object.headers['User-Agent']).as_json[:parsed_data]
  end
end
