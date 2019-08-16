# frozen_string_literal: true

class OccurrenceCollectionSerializer < ApplicationSerializer
  attribute :total_count
  has_many :events, each_serializer: EventSerializer

  def events
    object.group_by_day(&:created_at)
  end

  def total_count
    object.total_count
  end
end
