# frozen_string_literal: true

class Events::OccurrencesService < ApplicationService
  def call
    events
  end

  private

  def events
    @events ||= project.events.by_parent(declared_params[:parent_id])
  end

  def project
    @project ||= user.projects.find(declared_params[:project_id])
  end
end
