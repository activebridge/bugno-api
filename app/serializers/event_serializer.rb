# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  attributes :id, :title, :environment, :status, :user_id, :project_id,
             :message, :backtrace, :framework, :url, :ip_address, :headers,
             :http_method, :params, :position, :server_data, :created_at,
             :parent_id, :person_data, :route_params, :updated_at,
             :occurrence_count, :last_occurrence_at

  attribute :user_agent, if: proc { object.user_agent? && client.known? }

  def user_agent
    { browser: "#{client.name} #{client.full_version}",
      os: "#{client.os_name} #{client.os_full_version}",
      device: "#{client.device_name} #{client.device_type}" }
  end

  def client
    client = object.headers['User-Agent']
    @client ||= DeviceDetector.new(client)
  end
end
