# frozen_string_literal: true

class Events::OccurrencesService < ApplicationService
  def call
    params[:id] = event.parent_id if event.occurrence?
    occurrences
  end

  private

  def occurrences
    @occurrences ||= project.events
                            .by_parent(params[:id])
                            .order(created_at: :desc)
                            .page(params[:page])
  end

  def project
    @project ||= Project.find(params[:project_id])
  end

  def event
    @event ||= project.events.find(params[:id])
  end
end
