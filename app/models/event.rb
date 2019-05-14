# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true

  enum status: %i[active resolved muted]

  validates :title, :status, presence: true

  acts_as_list scope: %i[status project_id]
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_parent, -> { where('parent_id IS NULL') }

  before_create :set_parent

  def set_parent
    self.parent_id = ::Events::SetParentEventService.call(event: self, project: project)
  end
end
