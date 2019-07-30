# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true
  belongs_to :parent, class_name: 'Event', optional: true, counter_cache: :occurence_count
  has_many :occurences, class_name: 'Event', foreign_key: 'parent_id'

  attribute :framework, :string, default: :plain

  enum status: %i[active resolved muted]

  paginates_per 25

  validates :title, :status, presence: true

  acts_as_list scope: %i[status project_id]
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_parent, ->(parent_id) { where(parent_id: parent_id) if parent_id.present? }

  before_create :assign_parent
  after_save :brodcast
  after_save :update_active_parent_count

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
                                   EventSerializer.new(self, action: action).as_json)
    end
  end
end
