# frozen_string_literal: true

class EventCollectionSerializer < ApplicationSerializer
  attribute :total_count
  has_many :events, each_serializer: EventSerializer

  def events
    object
  end

  def total_count
    object.total_count
  end
end
