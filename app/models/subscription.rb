# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :plan, optional: true
  belongs_to :project
  attribute :expires_at, :date, default: 1.month.from_now

  enum status: %i[active expired]

  validates :status, :expires_at, presence: true
  validates :project, uniqueness: true

  scope :by_expiring, -> { where('expires_at <= ?', Time.now) }

  after_create :update_available_events_space

  def update_available_events_space
    update(events: plan.event_limit)
  end
end
