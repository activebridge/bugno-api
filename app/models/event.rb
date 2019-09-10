# frozen_string_literal: true

class Event < ApplicationRecord
  MESSAGE_MAX_LENGTH = 3000
  include PublicActivity::Common

  belongs_to :project
  belongs_to :user, optional: true
  belongs_to :parent, class_name: 'Event', optional: true, counter_cache: :occurrence_count
  has_many :occurrences, class_name: 'Event', foreign_key: 'parent_id'

  attribute :framework, :string, default: :plain

  enum status: %i[active resolved muted]

  paginates_per 25

  validates :title, :status, :framework, presence: true

  acts_as_list scope: %i[status project_id]
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_parent, ->(parent_id) { where(parent_id: parent_id) if parent_id.present? }

  before_create :assign_parent
  after_save :brodcast
  after_save :update_active_parent_count

  def message=(value)
    message = value.length > MESSAGE_MAX_LENGTH ? value.truncate(MESSAGE_MAX_LENGTH) : value
    super(message)
  end

  def created_at=(value)
    timestamp = value.is_a?(Integer) ? Time.at(value) : value
    super(timestamp)
  end

  def parent?
    parent_id.nil?
  end

  private

  def update_active_parent_count
    return if parent_id

    project.update!(active_event_count: project.active_events.size)
  end

  def assign_parent
    self.parent_id = ::Events::ParentCreateService.call(event: self, project: project)
  end

  def brodcast
    action = saved_change_to_id? ? UserChannel::ACTIONS::CREATE_EVENT : UserChannel::ACTIONS::UPDATE_EVENT
    return if parent_id

    project.project_users.each do |project_user|
      ActionCable.server.broadcast("user_#{project_user.user_id}",
                                   EventSerializer.new(self).as_json.merge(action: action))
    end
  end
end
