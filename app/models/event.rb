# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true

  enum status: %i[active resolved muted]

  validates :title, :status, presence: true
end
