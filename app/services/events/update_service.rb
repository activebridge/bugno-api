# frozen_string_literal: true

class Events::UpdateService < ApplicationService
  def call
    event if event.update(declared_params[:event])
  end

  private

  def event
    @event ||= project.events.find(declared_params[:id])
  end

  def project
    @project ||= user.projects.find(declared_params[:project_id])
  end
end
