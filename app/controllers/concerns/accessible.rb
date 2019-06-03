# frozen_string_literal: true

module Accessible
  extend ActiveSupport::Concern

  protected

  def authenticate_admin
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['ADMIN_USERNAME'] && \
        password == ENV['ADMIN_PASSWORD']
    end
    warden.custom_failure! if performed?
  end
end
