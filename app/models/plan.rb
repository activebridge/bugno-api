# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :subscriptions

  validates :name, presence: true, uniqueness: true, allow_nil: false
  validates :description, presence: true, uniqueness: true, allow_nil: false
  validates :price, presence: true, allow_nil: false
end
