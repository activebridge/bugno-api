# frozen_string_literal: true

class SubscriptionSerializer < ApplicationSerializer
  attributes :id, :expires_at, :status, :plan_id, :events, :updated_at

  belongs_to :plan
end
