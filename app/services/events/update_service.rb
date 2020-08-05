# frozen_string_literal: true

class Events::UpdateService < ApplicationService
  def call
    return unless event.update(params[:event])

    notify if event.saved_change_to_status?
    notify_assignee if notify_assignee?
    event
  end

  private

  def notify
    action = UserChannel::ACTIONS::UPDATE_EVENT
    Integration.notify(event: event, action: action, reason: @user.nickname)
  end

  def notify_assignee?
    assignee_id = params.dig(:event, :user_id)
    assignee_id.present? && assignee_id != @user.id && event.saved_change_to_user_id?
  end

  def notify_assignee
    EventMailer.assign(event, @user).deliver_later
  end

  def event
    @event ||= project.events.find(params[:id])
  end

  def project
    @project ||= @user.projects.find(params[:project_id])
  end
end
