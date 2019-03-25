# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :project_users
  has_many :projects, through: :project_users
end
