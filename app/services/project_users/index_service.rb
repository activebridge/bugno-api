# frozen_string_literal: true

class ProjectUsers::IndexService < ApplicationService
  def initialize(opts = {})
    super
  end

  def call
    project_users
  end

  private

  def project
    @project ||= user.projects.find(params[:project_id])
  end

  def project_users
    @project_users ||= project.project_users.includes(:user)
  end
end
