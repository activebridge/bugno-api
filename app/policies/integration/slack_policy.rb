# frozen_string_literal: true

class Integration::SlackPolicy < ApplicationPolicy
  def destroy?
    record.project_user_owner?(user)
  end
end
