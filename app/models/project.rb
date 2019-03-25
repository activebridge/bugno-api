# frozen_string_literal: true

class Project < ApplicationRecord
  has_secure_token :api_key

  validates :name, presence: true
end
