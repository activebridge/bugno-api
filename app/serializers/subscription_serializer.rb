# frozen_string_literal: true

class SubscriptionSerializer < ApplicationSerializer
  attributes :id, :expires_at, :status, :plan_id, :events, :updated_at
  attribute :plan do |object|
    PlanSerializer.new(object.plan).serializable_hash
  end
end
