# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  attributes :id, :title, :environment, :status, :user_id, :project_id,
             :message, :backtrace, :framework, :url, :ip_address, :headers,
             :http_method, :params, :position, :server_data, :created_at,
             :parent_id, :person_data, :route_params, :updated_at,
             :occurrence_count, :last_occurrence_at
  attribute :user, if: proc { instance_options[:include_user] && object.user }
  attribute :user_agent, if: proc { object.user_agent? }

  def user
    PublicUserSerializer.new(object.user).as_json
  end

  def user_agent
    DeviceDetectorSerializer.new(object.headers['User-Agent']).as_json[:parsed_data]
  end
end
