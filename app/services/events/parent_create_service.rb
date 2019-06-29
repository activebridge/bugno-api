# frozen_string_literal: true

class Events::ParentCreateService < ApplicationService
  def call
    if event['framework'] == 'browser-js'
      browser_js_parent&.id
    else
      project_error_trace && project_error_trace['code'] ? parent_by_backtrace&.id : parent_by_title&.id
    end
  end

  private

  def parent_by_backtrace
    query = 'parent_id IS NULL AND title = ? AND'\
            ' backtrace @> ARRAY[?]::jsonb[]'
    project.events.where(query, event['title'], project_error_trace.to_json)
           &.first
  end

  def parent_by_title
    project.events.find_by(title: event['title'], message: event['message'], parent_id: nil)
  end

  def project_error_trace
    event['backtrace'].find do |trace|
      trace['filename'].include?(event['server_data']['root'])
    end
  end

  def browser_js_parent
    project.events.find_by(message: event['message'], backtrace: event['backtrace'], parent_id: nil)
  end
end
