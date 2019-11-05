# frozen_string_literal: true

class Project < ApplicationRecord
  extend FriendlyId
  has_secure_token :api_key

  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :events, dependent: :delete_all
  has_many :active_events, -> { where(status: :active, parent_id: nil) }, class_name: 'Event'
  has_many :integrations, dependent: :destroy
  has_one :subscription, dependent: :destroy

  friendly_id :name, use: %i[slugged finders]
  validates :name, presence: true

  def should_generate_new_friendly_id?
    name_changed?
  end

  ProjectUser.roles.keys.each do |role|
    define_method "user_#{role}?" do |user|
      project_users.send(role).exists?(user: user)
    end
  end
end
