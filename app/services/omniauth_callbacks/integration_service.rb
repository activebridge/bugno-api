# frozen_string_literal: true

class OmniauthCallbacks::IntegrationService < ApplicationService
  include Verifiable
  def call
    project.integrations.create(type: integration_type, provider_data: omniauth_extra) if project.user_owner?(user)
  end

  private

  def integration_type
    @integration_type ||= "Integration::#{provider.capitalize}"
  end

  def project
    @project ||= Project.find(params['project_id'])
  end

  def user
    @user ||= User.find(verified_object[:id]) if verified_object[:id]
  end

  def verified_object
    @verified_object ||= verifier.verify(params['user_id'])
  rescue StandardError
    {}
  end
end
