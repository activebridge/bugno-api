# frozen_string_literal: true

class Integration::SlackPolicy < ApplicationPolicy
  def delete?
    record.project_user_owner?(user)
  end
end
