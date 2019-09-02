# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  def update?
    record.user_owner?(user)
  end

  alias destroy? update?
end
