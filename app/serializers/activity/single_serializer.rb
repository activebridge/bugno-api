# frozen_string_literal: true

class Activity::SingleSerializer < ApplicationSerializer
  attributes :parameters, :created_at, :owner_type, :trackable_type, :recipient_type,
             :owner, :trackable, :recipient

  %i[owner trackable recipient].each do |type|
    define_method type do
      item = object.send(type)
      "Activity::#{item.class.name}Serializer".constantize.new(item) if item
    end
  end
end
