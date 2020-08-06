# frozen_string_literal: true

class Events::BuildAttributesService < ApplicationService
  EXLCUDED_DIRECTORIES = ['vendor/', 'node_modules/']

  def call
    @params.merge(parent_id: parent_id, 'project_id' => @project.id)
  end

  private

  def parent_id
    if @params['framework'] == Constants::Event::BROWSER_JS
      browser_js_parent&.id
    elsif @params['backtrace']
      handle_backtrace_event
    else
      parent_by_title&.id
    end
  end

  def handle_backtrace_event
    assign_project_trace
    project_trace && project_trace['code'] ? parent_by_backtrace&.id : parent_by_title&.id
  end

  def parent_by_backtrace
    query = 'parent_id IS NULL AND title = ? AND backtrace @> ARRAY[?]::jsonb[]'
    @project.events.where(query, @params['title'], project_trace.except('project_error').to_json)&.first
  end

  def parent_by_title
    @project.events.find_by(title: @params['title'], message: @params['message'], parent_id: nil)
  end

  def browser_js_parent
    @project.events.find_by(message: @params['message'], parent_id: nil)
  end

  def assign_project_trace
    @params['backtrace'].each do |trace|
      trace['project_error'] = true if trace['filename'].include?(@params.dig('server_data', 'root')) &&
                                       !excluded_directory?(trace['filename'])
    end
  end

  def project_trace
    @params['backtrace'].find { |trace| trace['project_error'] }
  end

  def excluded_directory?(filename)
    EXLCUDED_DIRECTORIES.any? { |directory| filename.include?(directory) }
  end
end
