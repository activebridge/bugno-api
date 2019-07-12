# frozen_string_literal: true

class Plan < ApplicationRecord
  CENT_MULTIPLIER = 100

  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true

  def cent_price
    (price * CENT_MULTIPLIER).to_i
  end
end
