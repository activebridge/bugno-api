# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :plan, optional: true
  belongs_to :project
  attribute :expires_at, :date, default: 1.month.from_now

  delegate :cent_price, :name, to: :plan, allow_nil: true, prefix: true

  enum status: %i[active expired]

  validates :status, :expires_at, presence: true
  validates :project, uniqueness: true

  scope :by_expired, -> { where('expires_at <= ?', Time.now) }

  after_create :update_events
  after_update :check_status

  def check_status
    return if expired? || events.positive?

    expired!
  end

  def update_events
    update(events: plan.event_limit)
  end
end
