# frozen_string_literal: true

class Events::UpdateService < ApplicationService
  def call
    return unless event.update(declared_params[:event])

    if event.saved_changes['status']
      ::Activities::CreateService.call(key: :update, trackable: event, owner: user, recipient: project)
      notify
    end
    event
  end

  private

  def notify
    action = UserChannel::ACTIONS::UPDATE_EVENT
    Integration.notify(event: event, action: action, reason: user.nickname)
  end

  def event
    @event ||= project.events.find(declared_params[:id])
  end

  def project
    @project ||= user.projects.find(declared_params[:project_id])
  end
end
