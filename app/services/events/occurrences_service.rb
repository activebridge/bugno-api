# frozen_string_literal: true

class Events::OccurrencesService < ApplicationService
  def call
    events
  end

  private

  def events
    @events ||= project.events.by_parent(declared_params[:parent_id]).page(declared_params[:page])
  end

  def project
    @project ||= user.projects.find(declared_params[:project_id])
  end
end
