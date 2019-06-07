# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :subscriptions

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
end
