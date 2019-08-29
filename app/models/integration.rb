# frozen_string_literal: true

class Integration < ApplicationRecord
  belongs_to :project

  def notify; end

  def self.notify(data)
    find_each { |integration| integration.notify(*data) }
  end

  delegate :user_owner?, to: :project, allow_nil: true, prefix: true
end
