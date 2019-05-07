# frozen_string_literal: true

class ProjectUserPolicy < ApplicationPolicy
  def delete?
    record.project_user_owner?(user) && record.user != user
  end
end
