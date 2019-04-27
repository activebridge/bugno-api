# frozen_string_literal: true

class ProjectUserMailer < ApplicationMailer
  def create(project_user, invited_by)
    @project_user = project_user
    @project = project_user.project
    @user = project_user.user
    @invited_by = invited_by
    mail(to: @user.email,
         subject: 'Added to project')
  end

  def delete(project_user, removed_by)
    @project_user = project_user
    @project = project_user.project
    @user = project_user.user
    @removed_by = removed_by
    mail(to: @user.email,
         subject: 'Removed from project')
  end
end
