# frozen_string_literal: true

class Project < ApplicationRecord
  has_secure_token :api_key

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :events, dependent: :destroy
  has_one :subscription, dependent: :destroy

  validates :name, presence: true

  ProjectUser.roles.keys.each do |role|
    define_method "user_#{role}?" do |user|
      project_users.send(role).exists?(user: user)
    end
  end
end
