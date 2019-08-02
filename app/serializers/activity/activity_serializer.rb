# frozen_string_literal: true

class Activity::ActivitySerializer < ApplicationSerializer
  attributes :parameters, :created_at

  has_one :owner
  has_one :trackable
  has_one :recipient

  %i[owner trackable recipient].each do |type|
    define_method type do
      item = object.send(type)
      "Activity::#{item.class.name}Serializer".constantize.new(item)
    end
  end
end
