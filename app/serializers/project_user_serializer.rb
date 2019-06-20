# frozen_string_literal: true

class ProjectUserSerializer < ApplicationSerializer
  attributes :id, :project_id, :user_id, :role

  belongs_to :user
end
