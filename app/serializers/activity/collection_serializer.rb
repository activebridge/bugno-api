# frozen_string_literal: true

class Activity::CollectionSerializer < ApplicationSerializer
  attribute :activity_total_count

  has_many :activities, serializer: Activity::SingleSerializer

  def activity_total_count
    instance_options[:total_count]
  end

  def activities
    object
  end
end
