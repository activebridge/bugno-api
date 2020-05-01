# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable,
         :validatable
  include DeviseTokenAuth::Concerns::User

  validates :email, uniqueness: true

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users

  def assigns_count_in_project(project_id)
    Event.where(project_id: project_id, user_id: id).count
  end

  def assigned_in_project?(project_id)
    Event.where(project_id: project_id, user_id: id).any?
  end
end
