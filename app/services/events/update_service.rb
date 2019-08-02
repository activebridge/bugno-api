# frozen_string_literal: true

class Events::UpdateService < ApplicationService
  def call
    return unless event.update(declared_params[:event])

    event.create_activity(:update, owner: user,
                                   recipient: project,
                                   params: { status: { previous: changes['status'].first,
                                                       new: changes['status'].last } })
    occurrences.update_all(status: declared_params[:event][:status]) if declared_params[:event][:status].present?
    event
  end

  private

  def changes
    @changes ||= event.saved_changes
  end

  def event
    @event ||= project.events.find(declared_params[:id])
  end

  def occurrences
    @occurrences ||= project.events.where(parent_id: declared_params[:id])
  end

  def project
    @project ||= user.projects.find(declared_params[:project_id])
  end
end
