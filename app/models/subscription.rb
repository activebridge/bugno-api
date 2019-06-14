# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :project

  enum status: %i[active expired]

  validates :status, :expires_at, presence: true
  validates :project, uniqueness: true

  after_create :update_available_events_space

  def update_available_events_space
    update(events: plan.event_limit)
  end
end
