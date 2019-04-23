# frozen_string_literal: true

class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project
  enum role: %i[owner collaborator]

  validates :project_id, uniqueness: { scope: :user_id }

  delegate :user_owner?, :user_collaborator?, to: :project, allow_nil: true, prefix: true
end
