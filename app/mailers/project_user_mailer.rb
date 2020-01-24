# frozen_string_literal: true

class ProjectUserMailer < ApplicationMailer
  include Verifiable
  def invite(email, project, invited_by)
    @email = email
    @project = project
    @invited_by = invited_by
    @registration_token = verifier.generate(@project.id, expires_in: 1.week)
    @sign_up_url = "#{I18n.t("web_url.#{Rails.env}")}/landing?registration_token=#{@registration_token}"
    mail(to: @email, subject: default_i18n_subject(project_name: @project.name, inviter: @invited_by.email))
  end

  def create(project_user, invited_by)
    @project_user = project_user
    @project = project_user.project
    @user = project_user.user
    @invited_by = invited_by
    mail(to: @user.email, subject: default_i18n_subject)
  end

  def delete(project_user, removed_by)
    @project_user = project_user
    @project = project_user.project
    @user = project_user.user
    @removed_by = removed_by
    mail(to: @user.email, subject: default_i18n_subject)
  end
end
