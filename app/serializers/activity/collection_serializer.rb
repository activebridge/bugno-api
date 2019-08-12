# frozen_string_literal: true

class Activity::CollectionSerializer < ApplicationSerializer
  attribute :total_count

  has_many :activities, serializer: Activity::SingleSerializer

  def total_count
    object.total_count
  end

  def activities
    object
  end
end
