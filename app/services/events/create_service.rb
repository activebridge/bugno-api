# frozen_string_literal: true

class Events::CreateService < ApplicationService
  def call # rubocop:disable Metrics/AbcSize
    return event unless project

    ::Events::ResolveSourceCodeService.call(event: event, trace: event.backtrace[0]) if resolve_source?
    occurrence_limit_reached? ? push_occurrence : create_event
    parent.update(last_occurrence_at: Time.now) if event.occurrence?
    event
  end

  private

  def create_event
    project.with_lock { event.save }
  end

  def push_occurrence
    parent.occurrences.first.delete
    create_event
  end

  def resolve_source?
    event.framework == Constants::Event::BROWSER_JS && event.backtrace.present?
  end

  def project
    @project ||= Project.find_by(api_key: @params[:project_id])
  end

  def event
    @event ||= Event.new(event_attributes)
  end

  def event_attributes
    project ? built_attributes : @params
  end

  def parent
    @parent ||= Event.find(built_attributes[:parent_id])
  end

  def built_attributes
    @built_attributes ||= ::Events::BuildAttributesService.call(params: @params, project: project)
  end

  def occurrence_limit_reached?
    built_attributes[:parent_id] && parent.occurrence_limit_reached?
  end
end
