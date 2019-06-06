# frozen_string_literal: true

class Events::IndexService < ApplicationService
  def call
    events
  end

  private

  def events
    @events ||= project.events.where(parent_id: nil)
                       .by_status(declared_params[:status])
                       .order(position: :asc)
                       .page(declared_params[:page])
  end

  def project
    @project ||= user.projects.find(declared_params[:project_id])
  end
end
