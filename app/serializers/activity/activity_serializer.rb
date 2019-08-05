# frozen_string_literal: true

class Activity::ActivitySerializer < ApplicationSerializer
  attributes :parameters, :created_at, :owner_type, :trackable_type, :recipient_type,
             :total_activity_count

  has_one :owner
  has_one :trackable
  has_one :recipient

  def total_activity_count
    instance_options[:total_count]
  end

  %i[owner trackable recipient].each do |type|
    define_method type do
      item = object.send(type)
      "Activity::#{item.class.name}Serializer".constantize.new(item) if item
    end
  end
end
