# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :plan
  has_and_belongs_to_many :projects

  enum status: %i[active expired]

  validates :status, presence: true
  validates :expires_at, presence: true
end
