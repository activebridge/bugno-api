# frozen_string_literal: true

class ProjectUsers::CreateService < ApplicationService
  def call
    if user_by_email
      ProjectUserMailer.create(project_user, user).deliver_later if project_user.save
      return project_user
    end
    ProjectUserMailer.invite(declared_params[:email], project, user).deliver_later
    false
  end

  private

  def project
    @project ||= user.projects.find(params[:project_id])
  end

  def user_by_email
    @user_by_email ||= User.find_by(email: declared_params[:email])
  end

  def project_user
    @project_user ||= project.project_users.new(user: user_by_email, role: 1) if user_by_email
  end
end
