# frozen_string_literal: true

class Events::UpdateService < ApplicationService
  def call
    return unless event.update(declared_params[:event])

    occurrences.update_all(status: declared_params[:event][:status]) if declared_params[:event][:status].present?
    event
  end

  private

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
