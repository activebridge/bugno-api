# frozen_string_literal: true

module Accessible
  extend ActiveSupport::Concern

  protected

  def authenticate_admin
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials[:admin_username] && \
        password == Rails.application.credentials[:admin_password]
    end
    warden.custom_failure! if performed?
  end
end
