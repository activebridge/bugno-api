# frozen_string_literal: true

class ProjectUser < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :project_id, uniqueness: { scope: :user_id }
end
