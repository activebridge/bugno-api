# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call
    return event unless project

    assign_parent
    project.with_lock { event.save }
    event
  end

  private

  def project
    @project ||= Project.find_by(api_key: @params[:project_id])
  end

  def event
    @event ||= Event.new(@params.merge(project: project))
  end

  def parent
    @parent ||= event.parent
  end

  def assign_parent
    event.parent_id = ::Events::AssignParentService.call(event: event, project: project)
  end
end
