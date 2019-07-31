# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  attributes :id, :title, :environment, :status, :user_id, :project_id,
             :message, :backtrace, :framework, :url, :ip_address, :headers,
             :http_method, :params, :position, :server_data, :created_at,
             :parent_id, :person_data, :route_params, :action, :updated_at,
             :occurence_count, :project_slug

  def action
    instance_options[:action]
  end

  def project_slug
    object.project.slug
  end
end
