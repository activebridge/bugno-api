# frozen_string_literal: true

class User < ActiveRecord::Base
  include Verifiable
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

  after_create :verify_registration_token

  private

  def verify_registration_token
    if registration_token
      project_id = verifier.verify(registration_token)
      project_users.create(project_id: project_id, role: 'collaborator')
    end
  rescue StandardError
    {}
  end
end
