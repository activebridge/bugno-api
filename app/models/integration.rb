# frozen_string_literal: true

class Integration < ApplicationRecord
  belongs_to :project

  def notify; end

  def self.notify(event:, action:, reason: '')
    find_each do |integration|
      integration.notify(event: event, action: action, reason: reason) if integration.project_id == event.project_id
    end
  end

  delegate :user_owner?, to: :project, allow_nil: true, prefix: true
end
