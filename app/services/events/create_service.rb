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
    @event ||= Event.new(event_attributes)
  end

  def event_attributes
    return @params unless project

    parent_muted? ? cut_attributes : built_attributes
  end

  def parent_muted?
    built_attributes[:parent_id] && Event.find(built_attributes[:parent_id]).muted?
  end

  def cut_attributes
    built_attributes.slice(:id, :project_id, :title, :message, :framework, :parent_id).merge(status: :muted)
  end

  def built_attributes
    @built_attributes ||= ::Events::BuildAttributesService.call(params: @params, project: project)
  end
end
