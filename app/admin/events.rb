# frozen_string_literal: true

ActiveAdmin.register Event do
  permit_params :project_id, :user_id, :title, :environment, :status, :message,
                :backtrace, :framework, :url, :ip_address, :headers,
                :http_method, :params, :position, :server_data, :parent_id
end
