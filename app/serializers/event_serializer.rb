# frozen_string_literal: true

class EventSerializer < ApplicationSerializer
  attributes :id, :title, :environment, :status, :user_id, :project_id,
             :message, :backtrace, :framework, :url, :user_ip, :headers,
             :method, :params
end
