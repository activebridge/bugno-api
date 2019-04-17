# frozen_string_literal: true

class Project < ApplicationRecord
  has_secure_token :api_key

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :events, dependent: :destroy

  validates :name, presence: true
end
