# frozen_string_literal: true

class Events::UpdateService < ApplicationService
  def call
    return unless event.update(declared_params[:event])

    if event.saved_changes['status']
      create_activity
      occurrences.update_all(status: declared_params.dig(:event, :status))
    end
    event
  end

  private

  def create_activity
    event.create_activity(:update, owner: user,
                                   recipient: project,
                                   params: { status: { previous: event.saved_changes['status'].first,
                                                       new: event.saved_changes['status'].last } })
  end

  def event
    @event ||= project.events.find(declared_params[:id])
  end

  def occurrences
    @occurrences ||= event.occurrences
  end

  def project
    @project ||= user.projects.find(declared_params[:project_id])
  end
end
