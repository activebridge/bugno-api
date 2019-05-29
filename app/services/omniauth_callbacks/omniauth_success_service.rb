# frozen_string_literal: true

class OmniauthCallbacks::OmniauthSuccessService < ApplicationService
  include Verifiable
  def call
    user.save
    verify_registration_token(params['registration_token'], user) if params['registration_token']
  end

  private

  def verify_registration_token(registration_token, user)
    if registration_token
      project_id = verifier.verify(registration_token)
      user.project_users.create(project_id: project_id, role: 'collaborator')
    end
  rescue StandardError
    {}
  end
end
