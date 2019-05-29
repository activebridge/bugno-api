# frozen_string_literal: true

class User < ActiveRecord::Base
  attr_accessor :registration_token
  extend Devise::Models
  devise :database_authenticatable,
         :registerable,
         :validatable,
         :omniauthable
  include DeviseTokenAuth::Concerns::User

  validates :email, uniqueness: true, allow_nil: true

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
end
