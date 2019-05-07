# frozen_string_literal: true

class ProjectUsers::DeleteService < ApplicationService
  def initialize(opts = {})
    super
  end

  def call
    ProjectUserMailer.delete(project_user, user).deliver_now if project_user.destroy
    project_user
  end

  private

  def project
    @project ||= user.projects.find(params[:project_id])
  end

  def project_user
    @project_user ||= project.project_users.find(params[:id])
  end
end
