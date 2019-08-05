# frozen_string_literal: true

class Activity::ActivityCollectionSerializer < ApplicationSerializer
  attribute :total_activity_count

  has_many :activities, each_serializer: ActivitySerializer

  def total_activity_count
    instance_options[:total_count]
  end

  def activities
    object
  end
end
