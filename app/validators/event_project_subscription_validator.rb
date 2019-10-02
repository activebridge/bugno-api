# frozen_string_literal: true

class EventProjectSubscriptionValidator < ActiveModel::Validator
  def validate(record)
    return if record.project.blank? || record.persisted?
    return record.errors.add(:subscription, 'is absent') unless record.project_subscription
    return record.errors.add(:subscription, 'expired') if record.project_subscription.expired?
  end
end
