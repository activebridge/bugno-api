# frozen_string_literal: true

class Events::AssignParentService < ApplicationService
  EXLCUDED_DIRECTORIES = ['vendor/', 'node_modules/']

  def call
    if @event.framework == Constants::Event::BROWSER_JS
      browser_js_parent&.id
    else
      assign_project_trace
      project_trace && project_trace['code'] ? parent_by_backtrace&.id : parent_by_title&.id
    end
  end

  private

  def parent_by_backtrace
    query = 'parent_id IS NULL AND title = ? AND backtrace @> ARRAY[?]::jsonb[]'
    @project.events.where(query, @event.title, project_trace.except('project_error').to_json)&.first
  end

  def parent_by_title
    @project.events.find_by(title: @event.title, message: @event.message, parent_id: nil)
  end

  def browser_js_parent
    @project.events.find_by(message: @event.message, parent_id: nil)
  end

  def assign_project_trace
    @event.backtrace.each do |trace|
      trace['project_error'] = true if trace['filename'].include?(@event['server_data']['root']) && \
                                       !excluded_directory?(trace['filename'])
    end
  end

  def project_trace
    @event.backtrace.find { |trace| trace['project_error'] }
  end

  def excluded_directory?(filename)
    EXLCUDED_DIRECTORIES.any? { |directory| filename.include?(directory) }
  end
end
