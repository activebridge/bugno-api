# frozen_string_literal: true

class Events::ShowService < ApplicationService
  def call
    event
  end

  private

  def event
    @event ||= project.events.find(params[:id])
  end

  def project
    @project ||= user.projects.find(params[:project_id])
  end
end
