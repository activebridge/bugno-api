# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    return event unless project

    project.with_lock { event.save }
    event
  end

  private

  def project
    @project ||= Project.find_by(api_key: @params[:project_id])
  end

  def event
    @event ||= Event.new(project ? event_attributes : @params)
  end

  def event_attributes
    @event_attributes ||= ::Events::BuildAttributesService.call(params: @params, project: project).merge(project: project)
  end
end
