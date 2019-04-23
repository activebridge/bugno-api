# frozen_string_literal: true

class ProjectUserPolicy < ApplicationPolicy
  def create?
    record.project_user_owner?(user)
  end

  def delete?
    create? && record.user != user
  end
end
