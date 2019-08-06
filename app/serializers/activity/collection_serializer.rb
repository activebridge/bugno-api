# frozen_string_literal: true

class Activity::CollectionSerializer < ApplicationSerializer
  attribute :total_activity_count

  has_many :activities, serializer: Activity::SingleSerializer

  def total_activity_count
    instance_options[:total_count]
  end

  def activities
    object
  end
end
