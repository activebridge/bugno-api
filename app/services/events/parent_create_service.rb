# frozen_string_literal: true

class Events::ParentCreateService < ApplicationService
  def call
    if project_error_trace && project_error_trace['code']
      parent_by_backtrace&.id
    else
      parent_by_title&.id
    end
  end

  private

  def parent_by_backtrace
    error_line = project_error_trace['code'].gsub('"', '%"')
    filename = project_error_trace['filename']
    query = 'parent_id IS NULL AND title = ? AND'\
            ' backtrace::text ILIKE ? AND backtrace::text ILIKE ?'
    project.events.where(query, event['title'], "%#{error_line}%", "%#{filename}%")
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
end
