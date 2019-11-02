# frozen_string_literal: true

class Event < ApplicationRecord
  MESSAGE_MAX_LENGTH = 3000

  belongs_to :project
  belongs_to :user, optional: true
  belongs_to :parent, class_name: 'Event', optional: true, counter_cache: :occurrence_count
  has_many :occurrences, class_name: 'Event', foreign_key: 'parent_id', dependent: :delete_all

  attribute :framework, :string, default: :plain

  enum status: %i[active resolved muted]

  paginates_per 25

  validates :title, :status, :framework, presence: true
  validates_with EventProjectSubscriptionValidator
  delegate :subscription, to: :project, allow_nil: true, prefix: true

  acts_as_list scope: [:status, :project_id, parent_id: nil], top_of_list: 0
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_parent, ->(parent_id) { where(parent_id: parent_id) if parent_id.present? }

  before_create :assign_parent
  after_create :update_occurrence_at, if: :occurrence?
  after_create :reactivate_parent, if: -> { parent&.resolved? }
  after_create :update_subscription_events, if: -> { project&.subscription&.active? }
  after_update :update_occurrences_status, if: -> { parent? && saved_changes['status'] }
  # TODO: refactor repetition
  after_save :update_active_count, if: -> { parent? && active? }
  after_save :broadcast, if: :parent?
  after_destroy :update_active_count, if: -> { parent? && active? }
  after_destroy :broadcast, if: :parent?

  def message=(value)
    message = value.is_a?(String) && value.length > MESSAGE_MAX_LENGTH ? value.truncate(MESSAGE_MAX_LENGTH) : value
    super(message)
  end

  def created_at=(value)
    timestamp = value.is_a?(Integer) ? Time.at(value) : value
    super(timestamp)
  end

  def parent?
    parent_id.nil?
  end

  def occurrence?
    parent_id.present?
  end

  def user_agent?
    (headers && headers['User-Agent']).present?
  end

  private

  def update_subscription_events
    project.subscription.decrement(:events)
    project.subscription.save
  end

  def update_occurrences_status
    occurrences.update_all(status: status)
  end

  def reactivate_parent
    parent.active!
  end

  def update_occurrence_at
    parent.update!(last_occurrence_at: created_at)
  end

  def update_active_count
    project.update!(active_event_count: project.active_events.size)
  end

  def assign_parent
    self.parent_id = ::Events::ParentCreateService.call(event: self, project: project)
  end

  def broadcast
    action = saved_change_to_id? ? UserChannel::ACTIONS::CREATE_EVENT : UserChannel::ACTIONS::UPDATE_EVENT
    action = UserChannel::ACTIONS::DESTROY_EVENT if destroyed?

    project.project_users.each do |project_user|
      ActionCable.server.broadcast("user_#{project_user.user_id}",
                                   EventSerializer.new(self).as_json.merge(action: action))
    end
  end
end
