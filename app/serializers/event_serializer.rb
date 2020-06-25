# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  attributes :id, :title, :environment, :status, :user_id, :project_id,
             :message, :backtrace, :framework, :url, :ip_address, :headers,
             :http_method, :params, :position, :server_data, :created_at,
             :parent_id, :person_data, :background_data, :route_params,
             :updated_at, :occurrence_count, :last_occurrence_at, :user_email,
             :refer_url

  attribute :user_agent, if: proc { object.user_agent? }
  belongs_to :user, serializer: PublicUserSerializer

  def user_agent
    DeviceDetectorSerializer.new(object.headers['User-Agent']).as_json[:parsed_data]
  end

  def user_email
    object.person_data['email']
  end

  def refer_url
    object.headers['Referer']
  end
end
