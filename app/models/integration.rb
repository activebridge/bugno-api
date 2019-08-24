# frozen_string_literal: true

class Integration < ApplicationRecord
  belongs_to :project

  def notify; end

  delegate :user_owner?, to: :project, allow_nil: true, prefix: true
end
